import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/classes/album.dart';
import 'package:frontend/classes/artist.dart';
import 'package:frontend/classes/entity.dart';
import 'package:frontend/classes/track.dart';
import 'package:http/http.dart' as http;

enum SearchCategories { release, artist }

class SearchProvider extends ChangeNotifier {
  Map<String, String> get headers => {
    'Accept': 'application/json',
    'User-Agent': 'INM/0.3 (${_agentEmail ?? ""})',
  };

  String? _agentEmail;

  String? get agentEmail => _agentEmail;
  set agentEmail(String? email) {
    _agentEmail = email;
    notifyListeners();
  }

  bool _isSearching = false;
  bool isSearchInProgress = false;
  final int _searchlimit = 15;
  int _offSet = 0;

  String _searchCategory = "release-group";

  String get searchCategory => _searchCategory;
  set searchCategory(String category) {
    _searchCategory = category;
    notifyListeners();
  }

  String _querry = "";

  final _searchBarFocusNode = FocusNode();
  FocusNode get searchFocusNode => _searchBarFocusNode;

  set querry(String value) {
    _querry = value;
    notifyListeners();
  }

  bool get isSearching {
    return _isSearching;
  }

  int get offSet {
    return _offSet;
  }

  set isSearching(bool value) {
    _isSearching = value;
    notifyListeners();
  }

  Future<List<Entity>> search() async {
    if (_querry != "") {
      isSearchInProgress = true;
      final response = await http.get(
        Uri.parse(
          "https://musicbrainz.org/ws/2/$_searchCategory/?query=${Uri.encodeQueryComponent(_querry)}&limit=$_searchlimit&offset=$_offSet&fmt=json",
        ),
        headers: headers,
      );
      final bodyJson = json.decode(response.body);

      switch (searchCategory) {
        case 'release-group':
          return await _parseRelease(bodyJson['release-groups']);

        case 'artist':
          return await _parseArtist(bodyJson['artists']);
        default:
          return [];
      }
    } else {
      return [];
    }
  }

  void resetOffSet() {
    _offSet = 0;
    notifyListeners();
  }

  void setQuerry(String value) {
    _querry = value;
    notifyListeners();
  }

  void nextPage() {
    _offSet += _searchlimit;
    notifyListeners();
  }

  void previousPage() {
    if (_offSet != 0) {
      _offSet -= _searchlimit;
    }
    notifyListeners();
  }

  Future<List<Album>> _parseRelease(List<dynamic> releases) async {
    List<Album> albums = [];

    for (var group in releases) {
      final release = group['releases'][0];
      print(release);
      final id = release['id'];
      final coverUrl = 'https://coverartarchive.org/release/$id/front-500.jpg';

      final album = Album(
        id: id,
        title: release['title'],
        coverUrl: coverUrl,
        numberOfTracks: release['track-count'], 
        tracks: await retrieveSongs(id),
        cover: Image.network(
          coverUrl,
          errorBuilder: (context, error, stackTrace) {
            return Image(image: AssetImage('assets/default.png'));
          },
        ),
      );
      album.calculateAlbumDuration();
      albums.add(album);
    }
    return albums;
  }

  Future<List<Track>> retrieveSongs(String albumId) async {
    final response = await http.get(
      Uri.parse(
        "https://musicbrainz.org/ws/2/release/$albumId?inc=recordings+media&fmt=json",
      ),
      headers: headers,
    );
    final jsonBody = json.decode(response.body);
    notifyListeners();
    return parseTracksFromJson(jsonBody);
  }
  /*
  List<Album> retriveArtistReleases(String artistId) async{
    final releasesResponse = await http.get(Uri.parse(
    'https://musicbrainz.org/ws/2/release?artist=$artistId&type=album&fmt=json&limit=100',

  ));

  }
 */

  List<Track> parseTracksFromJson(Map<String, dynamic> json) {
    List<Track> tracks = [];
    try {
      final mediaList = json['media'] as List<dynamic>? ?? [];

      if (mediaList.isNotEmpty) {
        final media = mediaList[0] as Map<String, dynamic>;

        final trackList = media['tracks'] as List<dynamic>? ?? [];

        for (var track in trackList) {
          try {
            if (track is Map<String, dynamic>) {
              final id = track['id'];
              final title = track['title'] as String? ?? 'Unknown Track';
              final position = track['position'] as int;
              final length = track['length'] as int;

              tracks.add(
                Track(
                  id: id,
                  title: title,
                  numberOnTheAlbum: position,
                  duration: length,
                ),
              );
            }
          } catch (e) {
            debugPrint('Error parsing individual track: $e');
            continue;
          }
        }
      } else {
        debugPrint("This media list is empty");
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return tracks;
  }

  Future<List<Artist>> _parseArtist(List<dynamic> artistsJson) async {
    List<Artist> artists = [];
    for (var artist in artistsJson) {
      print(artist);
      artists.add(Artist.fromJson(artist));
    }
    return artists;
  }
}
