import 'package:flutter/material.dart';
import 'package:frontend/classes/album.dart';
import 'package:frontend/classes/track.dart';


class AlbumProvider with ChangeNotifier {
  List<Album> _albums = [];

  final List<Track> _tracks = [];

  List<Album> get albums => _albums;
  List<Track> get tracks => _tracks;


  



  set albums(List<Album> newAlbums) {
    _albums = newAlbums;
    notifyListeners(); // This is crucial for UI updates
  }

  List<Album> getAllAlbums() {
    return albums;
  }




}
