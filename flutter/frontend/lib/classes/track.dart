import 'package:frontend/classes/entity.dart';

class Track extends Entity {
  final int _durationInSeconds;
  final int _numberOnTheAlbum;
  final bool _live;
  final bool _single;
  final String? _albumId;

  int get durationInSeconds => _durationInSeconds;

  int get numberOnTheAlbum => _numberOnTheAlbum;

  bool get live => _live;

  bool get single => _single;

  String? get albumId => _albumId;

  void validateTrack() {
    if (durationInSeconds < 0) {
      throw ArgumentError("Track duration cannot be negative");
    }
    if (numberOnTheAlbum < 0) {
      throw ArgumentError("Track number on the album cannot be negative");
    }
  }

  Track({
    required super.id,
    required super.title,
    int durationInSeconds = 0,
    required int numberOnTheAlbum,
    bool live = false,  
    bool single = false,
    String? albumId,
  }) : _albumId = albumId, _single = single, _numberOnTheAlbum = numberOnTheAlbum, _live = live, _durationInSeconds = durationInSeconds;
  // OBSOLETE : must be rewritten to fit the new scheme

  // factory Track.fromJson(Map<String, dynamic> json) {
  //   return Track(
  //     id: json['id'],
  //     title: json['title'],
  //     durationInSeconds: json['duration'],
  //     numberOnTheAlbum: json['no_on_the_album'],
  //     live: json['is_a_live'],
  //     single: json['is_a_single'],
  //   );
  // }
}
