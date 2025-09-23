import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for HapticFeedback
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
            HapticFeedback.mediumImpact(); // Use the built-in class
            if (direction == DismissDirection.startToEnd) {
              // Swiped Right -> Archive (now Beaten)
              ref.read(gameListProvider.notifier).updateGameStatus(game, GameStatus.beaten);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${game.title} archived')));
            } else {
              // Swiped Left -> Delete
              ref.read(gameListProvider.notifier).deleteGame(game);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${game.title} deleted')));
            }
          },
          child: GameCard(game: game),
        );
      },
    );
  }
}