import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamelog/models/game.dart';
import 'package:gamelog/providers/game_provider.dart';
import 'package:gamelog/widgets/game_card.dart';

class BacklogScreen extends ConsumerWidget {
  const BacklogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Game> games = ref.watch(backlogProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Backlog')),
      body: ListView.builder(
        itemCount: games.length,
        itemBuilder: (context, index) {
          final game = games[index];
          return Dismissible(
            key: ValueKey(game.key),
            // SWIPE RIGHT -> NOW PLAYING
            background: _buildSwipeBackground(
              color: Colors.blue,
              icon: Icons.play_circle_outline,
              alignment: Alignment.centerLeft,
            ),
            // SWIPE LEFT -> ARCHIVE
            secondaryBackground: _buildSwipeBackground(
              color: Colors.green,
              icon: Icons.archive,
              alignment: Alignment.centerRight,
            ),
            onDismissed: (direction) {
              HapticFeedback.mediumImpact();
              if (direction == DismissDirection.startToEnd) { // Right
                ref.read(gameListProvider.notifier).updateGameStatus(game, GameStatus.nowPlaying);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${game.title} moved to Now Playing')));
              } else { // Left
                ref.read(gameListProvider.notifier).updateGameStatus(game, GameStatus.beaten);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${game.title} moved to Archive')));
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