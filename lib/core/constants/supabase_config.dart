import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConfig {
  SupabaseConfig._();

  static String get url {
    final url = const String.fromEnvironment('SUPABASE_URL');
    if (url.isNotEmpty) return url;
    // Fallback to runtime env (flutter_dotenv)
    try {
      return dotenv.env['SUPABASE_URL'] ?? '';
    } catch (_) {
      return '';
    }
  }

  static String get anonKey {
    final key = const String.fromEnvironment('SUPABASE_ANON_KEY');
    if (key.isNotEmpty) return key;
    try {
      return dotenv.env['SUPABASE_ANON_KEY'] ?? '';
    } catch (_) {
      return '';
    }
  }

  static bool get isConfigured => url.isNotEmpty && anonKey.isNotEmpty;
}
