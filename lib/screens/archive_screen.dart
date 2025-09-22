import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamelog/models/game.dart';
import 'package:gamelog/providers/game_provider.dart';
import 'package:gamelog/widgets/game_card.dart';

class ArchiveScreen extends ConsumerWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch our new provider for archived games
    final List<Game> games = ref.watch(archiveProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Archive'),
      ),
      body: ListView.builder(
        itemCount: games.length,
        itemBuilder: (context, index) {
          final game = games[index];
          return Dismissible(
            key: ValueKey(game.key),

            // Background for SWIPE RIGHT (Unarchive)
            background: Container(
              color: Colors.blue,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20.0),
              child: const Icon(Icons.unarchive, color: Colors.white),
            ),

            // Background for SWIPE LEFT (Delete)
            secondaryBackground: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20.0),
              child: const Icon(Icons.delete_forever, color: Colors.white),
            ),

            onDismissed: (direction) {
              if (direction == DismissDirection.startToEnd) {
                // Swiped Right: Unarchive the game
                // We set its status back to 'notStarted' to put it on the active list
                game.status = GameStatus.notStarted;
                ref.read(gameListProvider.notifier).updateGame(game);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${game.title} unarchived')),
                );
              } else {
                // Swiped Left: Permanently delete the game
                ref.read(gameListProvider.notifier).deleteGame(game);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${game.title} permanently deleted')),
                );
              }
            },

            child: GameCard(game: game),
          );
        },
      ),
    );
  }
}