import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamelog/models/game.dart';
import 'package:gamelog/providers/game_provider.dart';
import 'package:gamelog/widgets/game_card.dart';

class GameListView extends ConsumerWidget {
  final List<Game> games;
  const GameListView({super.key, required this.games});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (games.isEmpty) {
      return const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "No games in this list yet!\nUse the '+' button to add one.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          )
      );
    }

    return ListView.builder(
      itemCount: games.length,
      itemBuilder: (context, index) {
        final game = games[index];
        return Dismissible(
          key: ValueKey(game.key),
          background: Container(
            color: Colors.green,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20.0),
            child: const Icon(Icons.archive, color: Colors.white),
          ),
          secondaryBackground: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20.0),
            child: const Icon(Icons.delete_forever, color: Colors.white),
          ),
          onDismissed: (direction) {
            HapticFeedback.mediumImpact();

            // Store a copy of the game and its original status BEFORE changing it
            final originalGame = Game(
              title: game.title,
              platform: game.platform,
              genre: game.genre,
              status: game.status,
              dateAdded: game.dateAdded,
            );

            String message = '';
            SnackBarAction? undoAction;

            if (direction == DismissDirection.startToEnd) {
              // --- ARCHIVE LOGIC ---
              message = '${game.title} archived';
              ref.read(gameListProvider.notifier).updateGameStatus(game, GameStatus.beaten);

              undoAction = SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  // Revert the status change
                  ref.read(gameListProvider.notifier).updateGameStatus(game, originalGame.status);
                },
              );

            } else {
              // --- DELETE LOGIC ---
              message = '${game.title} deleted';
              ref.read(gameListProvider.notifier).deleteGame(game);

              undoAction = SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  // Re-add the deleted game
                  ref.read(gameListProvider.notifier).addGame(originalGame);
                },
              );
            }

            // Hide any currently showing SnackBars before showing a new one
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            // Show the new SnackBar with the message and the Undo action
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  action: undoAction,
                )
            );
          },
          child: GameCard(game: game),
        );
      },
    );
  }
}