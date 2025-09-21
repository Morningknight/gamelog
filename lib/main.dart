import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // <-- THIS IS THE CRITICAL IMPORT
import 'package:gamelog/models/game.dart';
import 'package:gamelog/providers/game_provider.dart';
import 'package:gamelog/screens/add_edit_game_screen.dart';
import 'package:gamelog/widgets/game_list_view.dart';
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
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  // A helper function to convert the enum to a display-friendly string
  String _filterTitle(GameFilter filter) {
    switch (filter) {
      case GameFilter.nowPlaying:
        return 'Now Playing';
      case GameFilter.beaten:
        return 'Beaten';
      case GameFilter.notStarted:
        return 'Not Started';
      case GameFilter.paused:
        return 'Paused';
      case GameFilter.dropped:
        return 'Dropped';
      case GameFilter.all:
        return 'All Games';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We watch gameProvider. It now provides the filtered list automatically.
    final List<Game> games = ref.watch(gameProvider);
    // We also watch the filter provider to display the current filter title.
    final currentFilter = ref.watch(gameFilterProvider);

    return Scaffold(
      appBar: AppBar(
        // Show the current filter in the title
        title: Text(_filterTitle(currentFilter)),
        actions: [
          // This is our filter menu button
          PopupMenuButton<GameFilter>(
            icon: const Icon(Icons.filter_list),
            onSelected: (filter) {
              // When a user selects a filter, we update the filter provider's state.
              ref.read(gameFilterProvider.notifier).state = filter;
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<GameFilter>>[
              const PopupMenuItem(value: GameFilter.all, child: Text('All')),
              const PopupMenuItem(value: GameFilter.nowPlaying, child: Text('Now Playing')),
              const PopupMenuItem(value: GameFilter.beaten, child: Text('Beaten')),
              const PopupMenuItem(value: GameFilter.paused, child: Text('Paused')),
              const PopupMenuItem(value: GameFilter.dropped, child: Text('Dropped')),
              const PopupMenuItem(value: GameFilter.notStarted, child: Text('Not Started')),
            ],
          ),
        ],
      ),
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