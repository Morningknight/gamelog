import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamelog/models/game.dart';
import 'package:gamelog/providers/game_provider.dart';
import 'package:gamelog/widgets/game_card.dart';

class ArchiveScreen extends ConsumerWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Game> games = ref.watch(archiveProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Archive')),
      body: ListView.builder(
        itemCount: games.length,
        itemBuilder: (context, index) {
          final game = games[index];
          return Dismissible(
            key: ValueKey(game.key),
            // SWIPE RIGHT -> BACKLOG
            background: _buildSwipeBackground(
              color: Colors.orange,
              icon: Icons.playlist_add,
              alignment: Alignment.centerLeft,
            ),
            // SWIPE LEFT -> NOW PLAYING
            secondaryBackground: _buildSwipeBackground(
              color: Colors.blue,
              icon: Icons.play_circle_outline,
              alignment: Alignment.centerRight,
            ),
            onDismissed: (direction) {
              HapticFeedback.mediumImpact();
              if (direction == DismissDirection.startToEnd) { // Right
                ref.read(gameListProvider.notifier).updateGameStatus(game, GameStatus.backlog);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${game.title} moved to Backlog')));
              } else { // Left
                ref.read(gameListProvider.notifier).updateGameStatus(game, GameStatus.nowPlaying);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${game.title} moved to Now Playing')));
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