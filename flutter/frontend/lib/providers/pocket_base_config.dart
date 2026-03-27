import 'package:frontend/classes/album.dart';
import 'package:frontend/classes/track.dart';
import 'package:frontend/utils/logger.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:flutter_test/flutter_test.dart';

///
///This class handles connection to the pocketbase instance
///

class PocketBaseConfig {
  static const String _pocketUrl = 'http://127.0.0.1:8090/';

  static const String _albumsCollection = 'albums';
  static const String _tracksCollection = 'tracks';

  static const Duration _timeoutDuration = Duration(seconds: 10);

  static final PocketBase _pocketBase = PocketBase(_pocketUrl);

  /// Creates a new album record in the pocketbase collection
  ///
  /// [parameterName] [album] The album to be created
  ///

  static Future<Album> createAlbum(Album album) async {
    try {
      logger.d('Creating album: ${album.title}');
      album.validateAlbum();
      await _pocketBase
          .collection(_albumsCollection)
          .create(
            body: {
              'id': album.id,
              'title': album.title,
              'number_of_tracks': album.numberOfTracks,
              'duration_in_seconds': album.durationInSeconds,
            },
          )
          .timeout(_timeoutDuration);
      logger.d('Creating tracks for album: ${album.title}');
      for (Track track in album.tracks) {
        await createTrack(track);
      }
      logger.i('Album created successfully: ${album.title}');
      return album;
    } on ClientException catch (e) {
      _parsePocketBaseError(e);
      rethrow;
    } on ArgumentError catch (e) {
      logger.e('Validation error for ${album.title}: $e');
      rethrow;
    } catch (e) {
      logger.e('Error creating ${album.title}: $e');
      rethrow;
    }
  }

  /// Creates a new track record in the pocketbase collection, optionally creating an album record if specified
  /// [parameterName] [track] The track to be created
  /// [parameterName] [createAlbumForTrack] If true, an album record will be created for the track if it does not already exist

  static Future<Track> createTrack(
    Track track, [
    bool createAlbumForTrack = false,
  ]) async {
    if (createAlbumForTrack) {
      try {
        logger.d('Creating album for track: ${track.title}');

        await _pocketBase
            .collection(_albumsCollection)
            .create(body: {'id': track.albumId, 'title': 'Unknown Album'})
            .timeout(_timeoutDuration);
        logger.i(
          'Album with id ${track.albumId} created for track ${track.title}',
        );
      } on ClientException catch (e) {
        _parsePocketBaseError(e);
        rethrow;
      } on ArgumentError catch (e) {
        logger.e('Validation error for track ${track.title}: $e');
        rethrow;
      } catch (e) {
        logger.e('Error creating album for track ${track.title}: $e');
        rethrow;
      }
    }

    try {
      logger.d('Creating track: ${track.title}');
      await _pocketBase
          .collection(_tracksCollection)
          .create(
            body: {
              'id': track.id,
              "durationInSeconds": track.durationInSeconds,
              "title": track.title,
              "numberOnTheAlbum": track.numberOnTheAlbum,
              "live": track.live,
              "single": track.single,
              'albumId': track.albumId,
            },
          )
          .timeout(_timeoutDuration);
      logger.i('Track created successfully: ${track.title}');
      return track;
    } catch (e) {
      logger.e('Error creating ${track.title}: $e');
      rethrow;
    }
  }

  /// Retrieves albums from the pocketbase collection, including their associated tracks
  /// [return] A list of albums with their tracks

  static Future<List<Album>> getAlbums() async {
    try {
      final albumResponse = await _pocketBase
          .collection(_albumsCollection)
          .getFullList()
          .timeout(_timeoutDuration);
      List<Album> albums = [];
      logger.d('Retrieved ${albumResponse.length} albums from pocketbase');
      for (var albumData in albumResponse) {
        Album album = Album(
          id: albumData.id,
          title: albumData.data['title'],
          numberOfTracks: albumData.data['number_of_tracks'],
          durationInSeconds: albumData.data['duration_in_seconds'],
        );
        logger.d('Retrieving tracks for album: ${album.title}');
        album.tracks = await getTracks(album.id).timeout(_timeoutDuration);
        logger.d(
          'Tracks retrieved for album: ${album.title}, count: ${album.tracks.length}',
        );
        albums.add(album);
      }
      return albums;
    } on ClientException catch (e) {
      _parsePocketBaseError(e);
      return [];
    } catch (e) {
      logger.e('Error retrieving tracks: $e');
      return [];
    }
  }

  /// Retrieves tracks from the pocketbase collection, optionally filtered by album ID
  /// [parameterName] [forAlbumId] If provided, only tracks belonging to the specified album ID will be retrieved
  ///
  /// [return] A list of tracks, optionally filtered by album ID

  static Future<List<Track>> getTracks([String? forAlbumId]) async {
    List<Track> tracks = [];
    try {
      final tracksResponse = await _pocketBase
          .collection(_tracksCollection)
          .getFullList(
            filter: forAlbumId != null ? 'albumId = "$forAlbumId"' : null,
          )
          .timeout(_timeoutDuration);
      logger.d('Retrieved ${tracksResponse.length} tracks from pocketbase');
      for (var trackData in tracksResponse) {
        Track track = Track(
          id: trackData.data['id'],
          title: trackData.data['title'],
          durationInSeconds: trackData.data['durationInSeconds'],
          numberOnTheAlbum: trackData.data['numberOnTheAlbum'],
          live: trackData.data['live'],
          single: trackData.data['single'],
          albumId: forAlbumId ?? trackData.data['albumId'],
        );
        tracks.add(track);
      }
      return tracks;
    } on ClientException catch (e) {
      _parsePocketBaseError(e);
      return [];
    } catch (e) {
      logger.e('Error retrieving tracks: $e');
      return [];
    }
  }

    /// Deletes an album record from the pocketbase collection, optionally deleting associated tracks
    /// [parameterName] [album] The album to be deleted
    /// [parameterName] [deleteTracks] If true, all tracks associated with the album will also be deleted

  static Future<void> deleteAlbum(Album album, [bool deleteTracks = false]) async {
    try{

      if (deleteTracks){
        logger.i('Deleting tracks on album ": ${album.title}');
          for (Track track in album.tracks) {
            await deleteTrack(track);
          }
      }
      
      logger.i('Deleting album : ${album.title}');
      await _pocketBase.collection(_albumsCollection).delete(album.id).timeout(_timeoutDuration);

      
    }
    on ArgumentError catch (e) {
      logger.e('Validation error for ${album.title}: $e');
      rethrow;
    }
    on ClientException catch (e) {
      _parsePocketBaseError(e);
      rethrow;
    }
    catch(e){
      logger.e('Error deleting album ${album.title} : $e');
      rethrow;  
    }
  }

  /// Deletes a track record from the pocketbase collection
  /// [parameterName] [track] The track to be deleted

  static Future<void> deleteTrack(Track track) async{
    try{
      track.validateTrack();
      logger.d('Deleting track : ${track.title}');
      await _pocketBase.collection(_tracksCollection).delete(track.id).timeout(_timeoutDuration);
    }
    on ArgumentError catch (e) {
      logger.e('Validation error for track ${track.title}: $e');
      rethrow;
    }
    on ClientException catch (e) {
      _parsePocketBaseError(e);
      rethrow;
    }
    catch(e){
      logger.e('Error deleting track ${track.title} : $e');
      rethrow;
    }
  }
}

void main() {
  group('PocketBaseConfig Integration Tests', () {
    test('createAlbum should create album and return record', () async {
      int trackCount = 3;
      final String testAlbumId = 'test${DateTime.now().millisecondsSinceEpoch}';
      final Album testAlbum = Album(
        id: testAlbumId,
        title: 'Test Album',
        numberOfTracks: trackCount,
        durationInSeconds: trackCount * 300,
        tracks: List.generate(
          trackCount,
          (index) => Track(
            id: 'track$index${DateTime.now().millisecondsSinceEpoch}',
            title: 'Track $index',
            durationInSeconds: 300,
            numberOnTheAlbum: index + 1,
            albumId: testAlbumId,
          ),
        ),
      );

      final record = await PocketBaseConfig.createAlbum(testAlbum);

      expect(record.id, equals(testAlbum.id));

      await PocketBaseConfig.deleteAlbum(testAlbum, true).then((_) {
        logger.i('Test album and tracks deleted successfully');
      });
    });
  });
}

/// Helper function to parse and log errors from pocketbase client exceptions
/// [parameterName] [e] The ClientException thrown by the pocketbase client

void _parsePocketBaseError(ClientException e) {
  final data = e.response['data'] as Map<String, dynamic>?;
  final status = e.response['status'] as int?;

  final message = data != null && data.isNotEmpty ? data['message'] as String : e.response['message'];
  final errorCode = data != null && data.isNotEmpty ?  data['id']['code']  : "Unknown error code";

  switch (errorCode) {
    case "validation_not_unique":
      logger.e("An entity with same id already exists.");
    case null:
      logger.e("$status : $message");
    case _:
      logger.e("An error occurred: $status - $message");
  }
}
