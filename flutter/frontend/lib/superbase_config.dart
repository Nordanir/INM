import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> initSupabase() async {
  await dotenv.load(fileName: '.env');
  String databaseUrl = dotenv.env['DATABASE_URL'] ?? '';
  String apikey = dotenv.env['API_KEY'] ?? '';
  await Supabase.initialize(url: databaseUrl, anonKey: apikey);
}
