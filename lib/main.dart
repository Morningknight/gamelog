import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamelog/models/game.dart';
import 'package:gamelog/providers/theme_provider.dart'; // Import theme provider
import 'package:gamelog/screens/main_screen.dart';
import 'package:gamelog/themes/app_themes.dart'; // Import themes
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(GameAdapter());
  await Hive.openBox<Game>('games');
  runApp(const ProviderScope(child: GameLogApp()));
}

// Make the app a ConsumerWidget to listen to the theme provider.
class GameLogApp extends ConsumerWidget {
  const GameLogApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the theme provider. When its state changes, this widget will rebuild.
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'GameLog',

      // Assign our custom themes
      theme: lightTheme,
      darkTheme: darkTheme,

      // Tell MaterialApp which theme to use based on the provider's state
      themeMode: themeMode,

      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}