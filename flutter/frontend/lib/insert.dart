import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient supabase = Supabase.instance.client;
Future<void> insertUser() async {
  await supabase.from("users").insert({"email": "jane.doe@example.com"});
}
