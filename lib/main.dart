import 'package:flutter/material.dart';
import 'package:gamelog/models/game.dart';
import 'package:gamelog/screens/add_edit_game_screen.dart'; // <-- ADD THIS IMPORT
import 'package:gamelog/widgets/game_list_view.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(GameAdapter());
  await Hive.openBox<Game>('games');
  runApp(const GameLogApp());
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
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Game> dummyGames = [
      Game(
        title: 'The Witcher 3: Wild Hunt',
        platform: 'PC',
        genre: 'Action RPG',
        status: 'Beaten',
        dateAdded: DateTime.now(),
      ),
      Game(
        title: 'Cyberpunk 2077',
        platform: 'PlayStation 5',
        genre: 'Action RPG',
        status: 'Now Playing',
        dateAdded: DateTime.now(),
      ),
      Game(
        title: 'Elden Ring',
        platform: 'PC',
        genre: 'Souls-like',
        status: 'Paused',
        dateAdded: DateTime.now(),
      ),
      Game(
        title: 'Hollow Knight',
        platform: 'Nintendo Switch',
        genre: 'Metroidvania',
        status: 'Not Started',
        dateAdded: DateTime.now(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My GameLog'),
      ),
      body: GameListView(games: dummyGames),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // --- UPDATE THIS PART ---
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => const AddEditGameScreen(),
            ),
          );
          // --- END OF UPDATE ---
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}