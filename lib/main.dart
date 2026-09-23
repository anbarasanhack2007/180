import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock portrait + landscape
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Status bar style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF0D1626),
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  // Initialize Supabase
  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
    // Run in offline/demo mode if no credentials provided
    debugPrint('''
⚠️  SUPABASE NOT CONFIGURED ⚠️
Please provide credentials by running:
  flutter run --dart-define=SUPABASE_URL=https://your-project.supabase.co \\
              --dart-define=SUPABASE_ANON_KEY=your-anon-key

Or set them in .env and pass via --dart-define.
See docs/SUPABASE_SETUP.md for full instructions.
''');
  } else {
    await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: supabaseAnonKey,
    );
  }

  runApp(
    const ProviderScope(
      child: CyberSprintApp(),
    ),
  );
}
