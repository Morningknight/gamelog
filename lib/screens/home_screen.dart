import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamelog/models/game.dart';
import 'package:gamelog/providers/game_provider.dart';
import 'package:gamelog/screens/about_screen.dart';
import 'package:gamelog/widgets/game_list_view.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

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
    final List<Game> games = ref.watch(gameProvider);
    final currentFilter = ref.watch(gameFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_filterTitle(currentFilter)),
        actions: [
          PopupMenuButton<GameFilter>(
            icon: const Icon(Icons.filter_list),
            onSelected: (filter) {
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
      // --- THE FLOATING ACTION BUTTON HAS BEEN REMOVED FROM THIS FILE ---
    );
  }
}