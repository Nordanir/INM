import 'package:flutter/material.dart';
import 'package:frontend/classes/album.dart';
import 'package:frontend/classes/track.dart';

class SelectionProvider with ChangeNotifier {
  Album? _selectedAlbum;
  Track? _selectedTrack;

  void changeSelectedAlbum(Album? album) {
    _selectedAlbum = album;
    notifyListeners();
  }

  void changeSelectedTrack(Track? track) {
    _selectedTrack = track;
    notifyListeners();
  }

  Album? get selectedAlbum {
    return _selectedAlbum;
  }

  Track? get selectedTrack {
    return _selectedTrack;
  }
}
