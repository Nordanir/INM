

import 'package:flutter/material.dart';


class AlbumProvider with ChangeNotifier {
  List<Album> _albums = [];
  
  List<Album> get albums => _albums;
  
  set albums(List<Album> newAlbums) {
    _albums = newAlbums;
    notifyListeners(); // This is crucial for UI updates
  }
  List<Album> getAllAlbums() {
    return albums;
  }

  void setAlbumsFromMap(List<Map<String, dynamic>> data) {
    albums.clear();
    for (var item in data) {
      albums.add(
        Album(
          id: item['id'],
          title: item['title'],
          duration: item['duration'],
          coverUrl: item['cover_url'],
          numberOfTracks: item['number_of_tracks']
        ),
      );
    }
    notifyListeners(); 
  }
}

class Album {
  final String id;
  final String title;
  final int duration;
  final int numberOfTracks;
  final String coverUrl;

  Album({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.duration,
    required this.numberOfTracks,
  });
}
