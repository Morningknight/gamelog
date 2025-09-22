import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamelog/models/game.dart';
import 'package:gamelog/providers/game_provider.dart';
import 'package:gamelog/screens/about_screen.dart';
import 'package:gamelog/widgets/game_list_view.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the new provider that only returns active games
    final List<Game> games = ref.watch(nowPlayingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
        actions: [
          // We will re-add the filter button here later if needed for the new design
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const AboutScreen()),
              );
            },
          ),
        ],
      ),
      body: GameListView(games: games),
      // NO FloatingActionButton should be in this file. It is managed by MainScreen.
    );
  }
}