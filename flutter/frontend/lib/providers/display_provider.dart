import 'package:flutter/material.dart';
import 'package:frontend/classes/album.dart';
import 'package:frontend/classes/entity.dart';
import 'package:frontend/classes/track.dart';
import 'package:frontend/providers/pocket_base_config.dart';
import 'package:frontend/utils/logger.dart';

class DisplayProvider with ChangeNotifier {
  Entity? _selectedEntity;
  Track? _selectedTrack;

  List<Entity> _allEntities = [];

  List<Entity> _displayEntities = [];

  bool _isLoading = false;

  List<Entity> get displayEntities => _displayEntities;

  bool get isLoading => _isLoading;

  set isLoading(bool value) => {_isLoading = value, notifyListeners()};

  List<Entity> get allEntities => _allEntities;

  set displayEntities(List<Entity> entities) {
    _displayEntities = entities;
    notifyListeners();
  }
  set allEntities(List<Entity> value) {
    _allEntities = value;
    notifyListeners();
  }

  Future<void> refresh() async {
  isLoading = true;
  
  try {
    final entities = await PocketBaseConfig.getAlbums();
    allEntities = entities;      // ✅ Uses setter
    displayEntities = entities;  // ✅ Uses setter
  } catch (e) {
    debugPrint('Error: $e');
  } finally {
    isLoading = false;
  }
}

  void changeSelectedEntity(Entity? entity) {
    _selectedEntity = entity;
    logger.i("Selected entity changed to: ${entity?.title}");
    notifyListeners();
  }

  set selectedEntity( Entity? entity) {
    _selectedEntity = entity;
    logger.i("Selected entity changed to: ${entity?.title}");
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
  

  void searchInEntities(String? query, List<Entity> entities) {
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
          (a, b) => (a as Album).durationInSeconds.compareTo(
            (b as Album).durationInSeconds,
          ),
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
