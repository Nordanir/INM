import 'package:flutter_dotenv/flutter_dotenv.dart';
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

  Future<void> signUpWithEmail(String email, String password) async {
    await _client.auth.signUp(email: email, password: password);
  }
}
