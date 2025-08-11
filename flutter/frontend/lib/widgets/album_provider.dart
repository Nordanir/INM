import 'package:flutter/material.dart';
import 'package:frontend/superbase_config.dart';

class AlbumProvider with ChangeNotifier {
  List<Album> _albums = [];
  List<Album> _displayingAlbums = [];
  Album? _selectedAlbum;
  final List<Track> _tracks = [];
  Track? _selectedTrack;

  List<Album> get displayingAlbums => _displayingAlbums;
  List<Album> get albums => _albums;
  List<Track> get tracks => _tracks;
  Track? get selectedTrack => _selectedTrack;
  Album? get selectedAlbum => _selectedAlbum;

  //This funciton calls supabase and sends a removal request to the database
  Future<void> deleteAlbum(Album album, SupabaseConfig supabase) async {
    try {
      // Delete from database first
      await supabase.removeAlbumFromDatabase(album);

      // Then remove from local state
      _albums.removeWhere((a) => a.id == album.id);
      _selectedAlbum = null;
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

  void changeSelectedAlbum(Album? album) {
    _selectedAlbum = album;
    notifyListeners();
  }

  void changeSelectedTrack(Track? track) {
    _selectedTrack = track;
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

//Album class representing a record release in an album format
class Album extends Entity {
  final String id;
  final String title;
  int duration;
  final int numberOfTracks;
  final String coverUrl;
  List<Track> tracks;
  Image? cover;

  void updateTracks(List<Track> newTracks) {
    tracks = newTracks;
    notifyListeners(); // Notify when tracks change
  }

  Album({
    required this.id,
    required this.title,
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

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
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
      ),
    );
  }
}

class Entity with ChangeNotifier {
  double? rating;

  void updateRating(double rating) {
    rating = rating;
    notifyListeners();
  }
}

class Track extends Entity {
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
