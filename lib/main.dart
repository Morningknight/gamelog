import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamelog/models/game.dart';
import 'package:gamelog/screens/main_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(GameAdapter());
  await Hive.openBox<Game>('games');
  runApp(const ProviderScope(child: GameLogApp()));
}

class GameLogApp extends StatelessWidget {
  const GameLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GameLog',
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF8A2BE2),
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF222222),
          elevation: 0,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: const Color(0xFF9D4EDD),
        ),
        colorScheme: const ColorScheme.dark().copyWith(
          primary: const Color(0xFF9D4EDD),
          secondary: const Color(0xFFC77DFF),
          onPrimary: Colors.white,
          surface: const Color(0xFF2C2C2C),
        ),
        // --- THIS IS THE CORRECTED LINE ---
        bottomAppBarTheme: const BottomAppBarThemeData(
          color: Color(0xFF222222),
          elevation: 0,
        ),
        // --- END OF CORRECTION ---
      ),
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}