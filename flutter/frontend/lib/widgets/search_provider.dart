import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/widgets/album_provider.dart';
import 'package:http/http.dart' as http;

class SearchProvider extends ChangeNotifier {
  Map<String, String> headers = {
    'Accept': 'application/json',
    'User-Agent': 'INM/1.0 (soosgabor0212@gmail.com)',
  };

  bool _toggleSearchBarVisibility = false;
  final int _searchlimit = 25;

  final _searchCategory = "release";
  String _querry = "";

  final _searchBarFocusNode = FocusNode();
  FocusNode get searchFocusNode => _searchBarFocusNode;

  List<dynamic> _searchResults = [];

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

  List<Album> _parseRelease(List<dynamic> releases) {
    List<Album> albums = [];
    releases.forEach((release) {
      final id = release['id'];
      final coverUrl = 'https://coverartarchive.org/release/$id/front-500.jpg';

      albums.add(
        Album(
          id: id,
          title: release['title'],
          coverUrl: coverUrl,
          numberOfTracks: release['track-count'],
          
        ),
      );
    });
    return albums;
  }

  Future<void> retrieveSongs(Album album) async {
    final response = await http.get(
      Uri.parse(
        "https://musicbrainz.org/ws/2/release/${album.id}?inc=recordings+media&fmt=json",
      ),
      headers: headers,
    );
    final jsonBody = json.decode(response.body);

    album.updateTracks(parseTracksFromJson(jsonBody));
    notifyListeners();
  }

  List<Track> parseTracksFromJson(Map<String, dynamic> json) {
    List<Track> tracks = [];

    final trackList = json['media'][0]["tracks"] as List<dynamic>;

    trackList.forEach((track) {
      tracks.add(
        Track(
          id: track['id'],
          title: track['title'],
          numberOnTheAlbum: track['position'] as int,
          duration: track['length'],
        ),
      );
    });

    return tracks;
  }

  SearchProvider() {
    _searchBarFocusNode.addListener(() {
      if (!_searchBarFocusNode.hasFocus) {
        _toggleSearchBarVisibility = false;
        notifyListeners();
      }
    });
  }

  bool get toggleSearchBarVisibility => _toggleSearchBarVisibility;

  void toggleSearchBar() {
    _toggleSearchBarVisibility = !_toggleSearchBarVisibility;
    if (_toggleSearchBarVisibility) {
      _searchBarFocusNode.requestFocus();
    } else {
      _searchBarFocusNode.unfocus();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _searchBarFocusNode.dispose();
    super.dispose();
  }
}
