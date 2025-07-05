import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/constants/widget_text.dart';
import 'package:frontend/widgets/util.dart';
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

  Future<void> signUpWithEmail(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      await _client.auth.signUp(email: email, password: password);
      displayMessage(context, succesfulRegistration);
    } on AuthApiException catch (e) {
      displayMessage(context, _getErrorMessage(e));
    }
  }

  Future<void> signInWithEmail(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
      displayMessage(context, successfulLogin);
    } on AuthApiException catch (e) {
      displayMessage(context, _getErrorMessage(e));
    }
  }

  String _getErrorMessage(AuthApiException e) {
    switch (e.code) {
      case 'invalid_email':
        return invalidEmail;
      case 'weak_password':
        return weakPassword;
      case 'email_already_in_use':
        return emailAlreadyInUse;
      case 'invalid_credentials':
        return loginError;

      default:
        return e.message;
    }
  }
}
