import 'package:supabase_flutter/supabase_flutter.dart';

class Supa {
  static SupabaseClient get client => Supabase.instance.client;
}

Future<void> initSupabase({required String url, required String anonKey}) {
  return Supabase.initialize(url: url, anonKey: anonKey);
}
