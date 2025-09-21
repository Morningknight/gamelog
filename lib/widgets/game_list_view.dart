import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamelog/models/game.dart';
import 'package:gamelog/providers/game_provider.dart';
import 'package:gamelog/screens/add_edit_game_screen.dart';
import 'package:gamelog/widgets/game_card.dart';

class GameListView extends ConsumerWidget {
  final List<Game> games;

  const GameListView({
    super.key,
    required this.games,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (games.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.gamepad_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Your backlog is empty!'),
            SizedBox(height: 8),
            Text('Tap the + button to add a game.'),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: games.length,
      itemBuilder: (context, index) {
        final game = games[index];

        // --- RESTORED THE DISMISSIBLE WIDGET ---
        // This is the final, correct architecture.
        return Dismissible(
          key: ValueKey(game.key),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20.0),
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            ref.read(gameListProvider.notifier).deleteGame(game);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${game.title} deleted'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          child: GameCard(
            game: game,
            onLongPress: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => AddEditGameScreen(game: game),
                ),
              );
            },
          ),
        );
      },
    );
  }
}