import 'package:flutter/material.dart';

class AlbumProvider with ChangeNotifier {
  List<Album> _albums = [];
  Album? _selectedAlbum;
  final List<Track> _tracks = [];
  Track? _selectedTrack;

  List<Album> get albums => _albums;
  List<Track> get tracks => _tracks;
  Track? get selectedTrack => _selectedTrack;
  Album? get selectedAlbum => _selectedAlbum;

  set albums(List<Album> newAlbums) {
    _albums = newAlbums;
    notifyListeners(); // This is crucial for UI updates
  }

  List<Album> getAllAlbums() {
    return albums;
  }

  void changeSelectedAlbum(Album? album) {
    _selectedAlbum = album;
    notifyListeners();
  }

  void changeSelectedTrack(Track? track) {
    _selectedTrack = track;
    notifyListeners();
  }
}

class Album with ChangeNotifier {
  final String id;
  final String title;
  final int duration;
  final int numberOfTracks;
  final String coverUrl;
  List<Track> tracks;

  void updateTracks(List<Track> newTracks) {
    tracks = newTracks;
    notifyListeners(); // Notify when tracks change
  }

  Album({
    required this.id,
    required this.title,
    required this.coverUrl,
    this.duration = 0,
    required this.numberOfTracks,
    this.tracks = const [],
  });
  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      numberOfTracks: json['number_of_tracks'],
      id: json['id'],
      title: json['title'],
      duration: json['duration'],
      coverUrl: json['cover_url'],
      tracks:
          ((json['tracks_of_album'] as List?) ?? [])
              .map((j) => Track.fromJson(j['tracks']))
              .toList()
            ..sort((a, b) => a.numberOnTheAlbum.compareTo(b.numberOnTheAlbum)),
    );
  }
}

class Track {
  final String id;
  final String title;
  final int duration;
  final int numberOnTheAlbum;
  final bool isALive;
  final bool isASingle;

  Track({
    required this.id,
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
