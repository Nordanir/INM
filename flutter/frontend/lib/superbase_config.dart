import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/constants/widget_text.dart';
import 'package:frontend/widgets/album_provider.dart';
import 'package:frontend/widgets/message_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  final SupabaseClient _client;

  SupabaseConfig(this._client);
  get databaseClient => _client;

  static Future<SupabaseConfig> initSupabase() async {
    await dotenv.load(fileName: ".env");
    String databaseUrl = dotenv.env['DATABASE_URL'] ?? '';
    String apikey = dotenv.env['API_KEY'] ?? '';
    await Supabase.initialize(url: databaseUrl, anonKey: apikey);
    SupabaseClient client = Supabase.instance.client;
    return SupabaseConfig(client);
  }

  Future<void> removeAlbumFromDatabase(Album album) async {
    try {
      // 1. Delete from tracks_of_album with proper error handling
      debugPrint('Deleting relationships for album ${album.id}...');

      await _client
          .from('tracks_of_album')
          .delete()
          .eq('album_id', album.id)
          .select('track_id') // Verify what was deleted
          .then((res) {
            debugPrint('Deleted ${res.length} relationships');
            return res;
          })
          .catchError((e) {
            debugPrint('Error deleting relationships: ${e.toString()}');
            throw e;
          });

      // 2. Delete tracks (one by one with error handling)
      debugPrint('Deleting ${album.tracks.length} tracks...');
      for (final track in album.tracks) {
        try {
          await _client.from('tracks').delete().eq('id', track.id);
        } catch (e) {
          debugPrint('Error deleting track ${track.id}: $e');
          // Continue with next track even if one fails
        }
      }

      // 3. Delete the album
      debugPrint('Deleting album ${album.id}...');
      await _client.from('albums').delete().eq('id', album.id);

      debugPrint('Successfully deleted album and all related data');
    } catch (e) {
      debugPrint('Critical error in removeAlbumFromDatabase:');
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> addAlbumToDatabase(Album album) async {
    try {
      // 1. First insert the album (single operation)
      await _client.from('albums').insert({
        'id': album.id,
        'title': album.title,
        'cover_url': album.coverUrl,
        'number_of_tracks': album.numberOfTracks,
        'duration': album.duration,
      });
      debugPrint("${album.title} added into albums");
      final trackInserts = album.tracks.map((track) {
        debugPrint("Inserting track: ${track.title}"); // Debug statement
        return _client.from('tracks').insert({
          // Explicit return
          'id': track.id,
          'title': track.title,
          'duration': track.duration,
          'no_on_the_album': track.numberOnTheAlbum,
          'is_a_live': track.isALive,
          'is_a_single': track.isASingle,
        });
      }).toList();

      await Future.wait(trackInserts);

      final relationshipInserts = album.tracks
          .map(
            (track) => _client.from('tracks_of_album').insert({
              'album_id': album.id,
              'track_id': track.id,
            }),
          )
          .toList();

      // 5. Execute all relationship inserts at once
      await Future.wait(relationshipInserts);
      debugPrint('Successfully added album with ${album.tracks.length} tracks');
    } on PostgrestException catch (e) {
      if (e.code == "23505") {
        debugPrint("This entry already exists");
      } else {
        debugPrint('Database error: ${e.code} - ${e.message}');
        debugPrint('Details: ${e.details}');
        rethrow;
      }
    } catch (e) {
      debugPrint('Unexpected error adding album: $e');
      rethrow;
    }
  }

  Future<bool> signUpWithEmail(String email, String password) async {
    try {
      await _client.auth.signUp(email: email, password: password);
      MessageDisplayer.setDisplay(succesfulRegistration);
      return true;
    } on AuthWeakPasswordException catch (_) {
      MessageDisplayer.setDisplay(weakPassword);
      return false;
    } on AuthApiException catch (e) {
      MessageDisplayer.setDisplay(_getErrorMessage(e));
      return false;
    }
  }

  Future<bool> signInWithEmail(String email, String password) async {
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
      MessageDisplayer.setDisplay(successfulLogin);
      return true;
    } on AuthApiException catch (e) {
      MessageDisplayer.setDisplay(_getErrorMessage(e));
      return false;
    }
  }

  String _getErrorMessage(AuthApiException e) {
    switch (e.code) {
      case 'invalid_email':
        return invalidEmail;
      case 'email_already_in_use':
        return emailAlreadyInUse;
      case 'invalid_credentials':
        return loginError;

      default:
        return e.message;
    }
  }

  Future<List<Album>> retrieveAlbums() async {
    final response = await _client.from('albums').select('''
            *,
            tracks_of_album(
              tracks(*)
            )
          ''');
    return (response as List).map((json) => Album.fromJson(json)).toList();
  }
}
