import 'package:flutter/material.dart';

import 'package:frontend/classes/album.dart';
import 'package:frontend/constants/widget_text.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig with ChangeNotifier {
  final SupabaseClient _client;

  SupabaseConfig(this._client);
  SupabaseClient get databaseClient => _client;

  bool? _isUserLoggedIn;
  User loggedInUser = User();
  Profile currentProfile = Profile();

  static Future<SupabaseConfig> initSupabase() async {
    final supabaseUrl = "https://rlfmtouqiopqsaworjpf.supabase.co";
    final anonAPIKey =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJsZm10b3VxaW9wcXNhd29yanBmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA3NjkzMDcsImV4cCI6MjA2NjM0NTMwN30.UvthMnLDJbH2ud9Cy15a5zHSGa_29hD-bLEABfM_gVs";
    await Supabase.initialize(url: supabaseUrl, anonKey: anonAPIKey);
    SupabaseClient client = Supabase.instance.client;
    return SupabaseConfig(client);
  }

  bool? get isUserLoggedIn => _isUserLoggedIn;
  void successfulLogin() {
    _isUserLoggedIn = true;
    notifyListeners();
  }

  Future<void> removeAlbumFromDatabase(Album album) async {
    try {
      // 1. Delete from tracks_of_album with proper error handling
      debugPrint('Deleting relationships for album ${album.id}...');

      await _client
          .from("entries_of_user")
          .delete()
          .eq('album_id', album.id)
          .eq('profile_id', currentProfile.profileId);

      final otherEntries = await _client
          .from("entries_of_user")
          .select("album_id")
          .eq('album_id', album.id);

      debugPrint(otherEntries.toString());

      if (otherEntries.isEmpty) {
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
      }
      debugPrint('Successfully deleted album and all related data');
    } catch (e) {
      debugPrint('Critical error in removeAlbumFromDatabase:');
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> addAlbumToDatabase(Album album) async {
    try {
      final response = await _client.from('albums').select().eq("id", album.id);

      if (response.toList().isEmpty) {
        await _client.from('albums').insert({
          'id': album.id,
          'title': album.title,
          'cover_url': album.coverUrl,
          'number_of_tracks': album.numberOfTracks,
          'duration': album.duration,
        });
        debugPrint("${album.title} added into albums");
        final trackInserts = album.tracks.map((track) {
          debugPrint("Inserting track: ${track.title}");
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

        debugPrint(
          'Successfully added album with ${album.tracks.length} tracks',
        );
      }

      await _client.from('entries_of_user').insert({
        'profile_id': currentProfile.profileId,
        'album_id': album.id,
      });
      debugPrint("${album.id} was added to user ");
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

  Future<(bool, String)> signUpWithEmail(
    String email,
    String password,
    String username,
  ) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );
      final userId = response.user!.id;
      await _client.from('profiles').insert({
        'username': username,
        "user_id": userId,
      });
      return (true, succesfulRegistration);
    } on AuthApiException catch (e) {
      return (false, _getErrorMessage(e));
    } on AuthWeakPasswordException catch (e) {
      return (false, weakPassword);
    }
  }

  Future<(bool, String)> signInWithEmail(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      loggedInUser.userId = response.user!.id;
      final profile = await _client
          .from('profiles')
          .select("profile_id,username")
          .eq('user_id', loggedInUser.userId)
          .single();
      currentProfile.profileId = profile['profile_id'];
      currentProfile.userName = profile['username'];
      return (true, loginSuccessfull);
    } on AuthApiException catch (e) {
      return (false, _getErrorMessage(e));
    }
  }

  Future<void> logout() async {
    await _client.auth.signOut();

    loggedInUser.logoutUser();
    _isUserLoggedIn = false;
    notifyListeners();
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
    final entriesOfProfile = await _client
        .from("entries_of_user")
        .select("album_id")
        .eq("profile_id", currentProfile.profileId);
    currentProfile._entriesOfProfile = entriesOfProfile
        .map((entry) => entry['album_id'].toString())
        .toList();

    if (entriesOfProfile.isEmpty) {
      debugPrint("Your database is empty");
      return [];
    }

    final response = await _client
        .from('albums')
        .select('''
            *,
            tracks_of_album(
              tracks(*)
            )
          ''')
        .inFilter("id", currentProfile._entriesOfProfile);

    return (response as List).map((json) => Album.fromJson(json)).toList();
  }
}

class User {
  String _userId = "";
  String _email = "";
  String _password = "";

  String get userId => _userId;
  String get email => _email;
  String get password => _password;

  set userId(String userId) => _userId = userId;
  set email(String email) => _email = email;
  set password(String password) => _password = password;

  void logoutUser() {
    userId = "";
    email = "";
    password = "";
  }
}

class Profile {
  String _profileId = "";
  String _userName = "";
  List<dynamic> _entriesOfProfile = [];

  String get userName => _userName;
  List<dynamic> get entriesOfProfile => _entriesOfProfile;
  String get profileId => _profileId;

  set userName(String userName) => _userName = userName;
  set profileId(String profileId) => _profileId = profileId;

  set entriesOfProfile(List<dynamic> entriesOfProfile) =>
      _entriesOfProfile = entriesOfProfile;
}
