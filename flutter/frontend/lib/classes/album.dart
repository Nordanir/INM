
import 'package:frontend/classes/artist.dart';
import 'package:frontend/classes/entity.dart';
import 'package:frontend/classes/track.dart';


class Album extends Entity {
  int _durationInSeconds;
  int _numberOfTracks;
  List<Track> _tracks;
  List<Artist> _artists = [];
  int get durationInSeconds => _durationInSeconds;

  set  durationInSeconds(int value) => _durationInSeconds = value;

  int get numberOfTracks => _numberOfTracks;

 set numberOfTracks( int value) => _numberOfTracks = value;

  List<Track> get tracks => _tracks;

 set tracks( List<Track> value) => _tracks = value;

  List<Artist> get artists => _artists;

 set artists( List<Artist> value) => _artists = value;

  void updateTracks(List<Track> newTracks) {
    _tracks = newTracks;
    notifyListeners();
  }

 void validateAlbum() {
    if (durationInSeconds < 0){
      throw ArgumentError("Album duration cannot be negative");
    }
    if (numberOfTracks < 0){
      throw ArgumentError("Album number of tracks cannot be negative");
    }}
  Album({
    required super.id,
    required super.title,
    super.coverUrl, 
    required int numberOfTracks,
    int durationInSeconds = 0,
    List<Track> tracks = const [],
    super.cover,
  }) : _tracks = tracks, _durationInSeconds = durationInSeconds, _numberOfTracks = numberOfTracks;

  void calculateAlbumDuration() {
    for (Track track in _tracks) {
      _durationInSeconds += track.durationInSeconds;
      notifyListeners();
    }
  
  }

    // OBSOLETE : must be revritten to fit the new scheme

  // factory Album.fromJson(Map<String, dynamic> json, double? rating) {
  //   final album = Album(
  //     durationInSeconds: json['duration'],
  //     numberOfTracks: json['number_of_tracks'],
  //     id: json['id'],
  //     title: json['title'],
  //     coverUrl: json['cover_url'],
  //     tracks:
  //         ((json['tracks_of_album'] as List?) ?? [])
  //             .map((j) => Track.fromJson(j['tracks']))
  //             .toList()
  //           ..sort((a, b) => a.numberOnTheAlbum.compareTo(b.numberOnTheAlbum)),
  //     cover: Image.network(
  //       json['cover_url'],
  //       errorBuilder: (context, error, stackTrace) {
  //         return Image(image: AssetImage('assets/default.png'));
  //       },
  //       fit: BoxFit.cover,
  //       loadingBuilder: (context, child, loadingProgress) {
  //         if (loadingProgress == null) return child;
  //         return const Center(child: CircularProgressIndicator());
  //       },
  //     ),
  //   );
  //   album.rating = rating;
  //   return album;
  // }
}
