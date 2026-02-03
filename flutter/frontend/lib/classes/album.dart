import 'package:flutter/material.dart';
import 'package:frontend/classes/artist.dart';
import 'package:frontend/classes/entity.dart';
import 'package:frontend/classes/track.dart';

class Album extends Entity {
  int duration;
  final int numberOfTracks;
  final String coverUrl;
  List<Track> tracks;
  Image? cover;
  List<Artist> artists = [];

  void updateTracks(List<Track> newTracks) {
    tracks = newTracks;
    notifyListeners(); // Notify when tracks change
  }

  Album({
    required super.id,
    required super.title,
    required this.coverUrl,
    required this.numberOfTracks,
    this.duration = 0,
    this.tracks = const [],
    this.cover,
  });

  void calculateAlbumDuration() {
    for (Track track in tracks) {
      duration += track.duration;
      notifyListeners();
    }
  }

  factory Album.fromJson(Map<String, dynamic> json, double? rating) {
    final album = Album(
      duration: json['duration'],
      numberOfTracks: json['number_of_tracks'],
      id: json['id'],
      title: json['title'],
      coverUrl: json['cover_url'],
      tracks:
          ((json['tracks_of_album'] as List?) ?? [])
              .map((j) => Track.fromJson(j['tracks']))
              .toList()
            ..sort((a, b) => a.numberOnTheAlbum.compareTo(b.numberOnTheAlbum)),
      cover: Image.network(
        json['cover_url'],
        errorBuilder: (context, error, stackTrace) {
          return Image(image: AssetImage('assets/default.png'));
        },
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
    album.rating = rating;
    return album;
  }
}
