import 'package:flutter/material.dart';
import 'package:frontend/classes/album.dart';
import 'package:frontend/classes/track.dart';
import 'package:frontend/providers/superbase_config.dart';

class AlbumProvider with ChangeNotifier {
  List<Album> _albums = [];
  List<Album> _displayingAlbums = [];
  final List<Track> _tracks = [];

  List<Album> get displayingAlbums => _displayingAlbums;
  List<Album> get albums => _albums;
  List<Track> get tracks => _tracks;

  //This funciton calls supabase and sends a removal request to the database
  Future<void> deleteAlbum(Album album, SupabaseConfig supabase) async {
    try {
      // Delete from database first
      await supabase.removeAlbumFromDatabase(album);

      // Then remove from local state
      _albums.removeWhere((a) => a.id == album.id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting album: $e');
      rethrow;
    }
  }

  set displayingAlbums(List<Album> albums) {
    _displayingAlbums = albums;
    notifyListeners();
  }

  set albums(List<Album> newAlbums) {
    _albums = newAlbums;
    notifyListeners(); // This is crucial for UI updates
  }

  List<Album> getAllAlbums() {
    return albums;
  }

  void searchInAlbums(String? query) {
    if (query == null || query.isEmpty) {
      displayingAlbums = albums;
      notifyListeners();
      return;
    }

    final pattern = RegExp(RegExp.escape(query.toLowerCase()));
    displayingAlbums = _albums
        .where((album) => pattern.hasMatch(album.title.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void sortAlbumsBy(String parameter, bool isAscending) {
    switch (parameter) {
      case "Title":
        displayingAlbums.sort((Album a, Album b) => a.title.compareTo(b.title));
        break;
      case "Duration":
        displayingAlbums.sort(
          (Album a, Album b) => a.duration.compareTo(b.duration),
        );
        break;
      case "Number of tracks":
        displayingAlbums.sort(
          (Album a, Album b) => a.numberOfTracks.compareTo(b.numberOfTracks),
        );
        break;
    }
    if (isAscending == false) {
      displayingAlbums = displayingAlbums.reversed.toList();
    }
    notifyListeners();
  }
}
