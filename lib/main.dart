import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamelog/models/game.dart';
import 'package:gamelog/providers/theme_provider.dart';
import 'package:gamelog/screens/main_screen.dart';
import 'package:gamelog/screens/onboarding_screen.dart'; // Import onboarding
import 'package:gamelog/themes/app_themes.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

// This will be our entry point widget.
late final bool hasSeenOnboarding;

void main() async {
  // We MUST ensure bindings are initialized for async operations in main.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(GameAdapter());
  Hive.registerAdapter(GameStatusAdapter());
  await Hive.openBox<Game>('games');
  await Hive.openBox('userSettings');

  // Initialize SharedPreferences and check our flag
  final prefs = await SharedPreferences.getInstance();
  // If the flag is null (first time ever), default to false.
  hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

  // Finally, run the app.
  runApp(const ProviderScope(child: GameLogApp()));
}

class GameLogApp extends ConsumerWidget {
  const GameLogApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'GameLog',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      // --- DYNAMIC HOME SCREEN ---
      // Use the flag to decide which screen to show first.
      home: hasSeenOnboarding ? const MainScreen() : const OnboardingScreen(),
    );
  }
}