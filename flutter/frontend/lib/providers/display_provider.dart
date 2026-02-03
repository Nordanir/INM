import 'package:flutter/material.dart';
import 'package:frontend/classes/album.dart';
import 'package:frontend/classes/entity.dart';
import 'package:frontend/classes/track.dart';

class DisplayProvider with ChangeNotifier {
  Entity? _selectedEntity;
  Track? _selectedTrack;

  List<Entity> _displayEntities = [];

  List<Entity> get displayEntities => _displayEntities;

  set displayEntities(List<Entity> entities) {
    _displayEntities = entities;
    notifyListeners();
  }

  void changeSelectedEntity(Entity? entity) {
    _selectedEntity = entity;
    notifyListeners();
  }

  void changeSelectedTrack(Track? track) {
    _selectedTrack = track;
    notifyListeners();
  }

  Entity? get selectedEntity {
    return _selectedEntity;
  }

  Track? get selectedTrack {
    return _selectedTrack;
  }

  void searchInAlbums(String? query, List<Entity> entities) {
    if (query == null || query.isEmpty) {
      displayEntities = entities;
      notifyListeners();
      return;
    }

    final pattern = RegExp(RegExp.escape(query.toLowerCase()));
    displayEntities = displayEntities
        .where((entity) => pattern.hasMatch(entity.title.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void sortAlbumsBy(String parameter, bool isAscending) {
    switch (parameter) {
      case "Title":
        displayEntities.sort(
          (a, b) => (a as Album).title.compareTo((b as Album).title),
        );
        break;
      case "Duration":
        displayEntities.sort(
          (a, b) => (a as Album).duration.compareTo((b as Album).duration),
        );
        break;
      case "Number of tracks":
        displayEntities.sort(
          (a, b) => (a as Album).numberOfTracks.compareTo(
            (b as Album).numberOfTracks,
          ),
        );
        break;
    }
    if (!isAscending) {
      displayEntities = displayEntities.reversed.toList();
    }
    notifyListeners();
  }
}
