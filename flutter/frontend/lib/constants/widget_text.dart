import 'package:frontend/classes/album.dart';
import 'package:frontend/classes/entity.dart';
import 'package:frontend/classes/track.dart';

String anonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJsZm10b3VxaW9wcXNhd29yanBmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA3NjkzMDcsImV4cCI6MjA2NjM0NTMwN30.UvthMnLDJbH2ud9Cy15a5zHSGa_29hD-bLEABfM_gVs';
String username = "Username";
String password = "Password";
String email = "E-Mail";
String rememberMe = "Remember Me ? ";
String loginButton = "Login";
String signUpButton = "Sign me up";
String registerButton = "Register";
String back = "Back";

String emailAlreadyInUse = "This email is already registered.";
String invalidEmail = "Invalid email address.";
String weakPassword = "Password is too weak (min 6 characters).";
String loginError = "Login failed. Please check your credentials.";

String succesfulRegistration =
    "Registration successful. Please check your email for confirmation.";
String loginSuccessfull = "Login successful. Welcome back!";

String albumTitle = "Album Title :";
String duration = "Duration :";
String numOfTracks = "Number of tracks :";

String noSearchResult =
    "Sorry, I couldn't find any results with those keywords. :(";
String emptyQuerry = "You searched with an empty querry";

String searching = 'Searching...';

String searchOnlineHint = "Search online...";

String supabaseUrl = 'https://rlfmtouqiopqsaworjpf.supabase.co';

String entityDeleted(Entity entity) {
  return '${entity.title} was deleted from your library.';
}

String entityAdded(Album entity) {
  return '${entity.title} was added to your library.';
}

String entryAlreadyExists(Album album) {
  return '${album.title} is already in your labrary';
}

String noTracksAvailable = "No tracks available";

String titleNthTrackOnTheAlbum(Album album, Track track) =>
    "${album.title} - ${track.numberOnTheAlbum}. track";

String noEntriesFound = "No entries found";
