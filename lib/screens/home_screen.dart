import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamelog/models/game.dart';
import 'package:gamelog/providers/game_provider.dart';
import 'package:gamelog/widgets/game_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Game> games = ref.watch(nowPlayingProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Now Playing')),
      body: ListView.builder(
        itemCount: games.length,
        itemBuilder: (context, index) {
          final game = games[index];
          return Dismissible(
            key: ValueKey(game.key),
            // SWIPE RIGHT -> ARCHIVE
            background: _buildSwipeBackground(
              color: Colors.green,
              icon: Icons.archive,
              alignment: Alignment.centerLeft,
            ),
            // SWIPE LEFT -> BACKLOG
            secondaryBackground: _buildSwipeBackground(
              color: Colors.orange,
              icon: Icons.playlist_add,
              alignment: Alignment.centerRight,
            ),
            onDismissed: (direction) {
              HapticFeedback.mediumImpact();
              if (direction == DismissDirection.startToEnd) { // Right
                ref.read(gameListProvider.notifier).updateGameStatus(game, GameStatus.beaten);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${game.title} moved to Archive')));
              } else { // Left
                ref.read(gameListProvider.notifier).updateGameStatus(game, GameStatus.backlog);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${game.title} moved to Backlog')));
              }
            },
            child: GameCard(game: game),
          );
        },
      ),
    );
  }

  Widget _buildSwipeBackground({required Color color, required IconData icon, required Alignment alignment}) {
    return Container(
      color: color,
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Icon(icon, color: Colors.white),
    );
  }
}