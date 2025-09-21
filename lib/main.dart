import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamelog/models/game.dart';
import 'package:gamelog/providers/game_provider.dart'; // <-- THIS IS THE FIX
import 'package:gamelog/screens/add_edit_game_screen.dart';
import 'package:gamelog/widgets/game_list_view.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(GameAdapter());
  await Hive.openBox<Game>('games');

  // Wrap the entire app in a ProviderScope
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
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

// MAKE HomeScreen a ConsumerWidget
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the gameProvider to get the list of games
    // This will automatically rebuild the widget when the list changes.
    final List<Game> games = ref.watch(gameProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My GameLog'),
      ),
      // Use the real list of games from the provider
      body: GameListView(games: games),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => const AddEditGameScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}