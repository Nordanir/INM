import 'package:frontend/classes/entity.dart';

class Track extends Entity {
  final String title;
  final int duration;
  final int numberOnTheAlbum;
  final bool isALive;
  final bool isASingle;

  Track({
    required super.id,
    required this.title,
    this.duration = 0,
    required this.numberOnTheAlbum,
    this.isALive = false,
    this.isASingle = false,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'],
      title: json['title'],
      duration: json['duration'],
      numberOnTheAlbum: json['no_on_the_album'],
      isALive: json['is_a_live'],
      isASingle: json['is_a_single'],
    );
  }
}
