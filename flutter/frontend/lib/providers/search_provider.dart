import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/classes/album.dart';
import 'package:frontend/classes/track.dart';
import 'package:http/http.dart' as http;

class SearchProvider extends ChangeNotifier {
  Map<String, String> headers = {
    'Accept': 'application/json',
    'User-Agent': 'INM/1.0 (soosgabor0212@gmail.com)',
  };

  bool isSearching = false;

  final int _searchlimit = 15;

  final _searchCategory = "release";
  String _querry = "";

  final _searchBarFocusNode = FocusNode();
  FocusNode get searchFocusNode => _searchBarFocusNode;

  final List<dynamic> _searchResults = [];

  List<dynamic> get searchResults => _searchResults;

  Future<List<Album>> searchFor() async {
    final response = await http.get(
      Uri.parse(
        "https://musicbrainz.org/ws/2/$_searchCategory/?query=${Uri.encodeQueryComponent(_querry)}&limit=$_searchlimit&offset=0&fmt=json",
      ),
      headers: headers,
    );
    final bodyJson = json.decode(response.body);
    return _parseRelease(bodyJson['releases']);
  }

  void setQuerry(String value) {
    _querry = value;
  }

  Future<List<Album>> _parseRelease(List<dynamic> releases) async {
    List<Album> albums = [];
    for (var release in releases) {
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
        debugPrint("The media list is empty");
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return tracks;
  }
}
