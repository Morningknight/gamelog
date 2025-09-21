import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // <-- ADD THIS
import 'package:gamelog/models/game.dart';
import 'package:gamelog/providers/game_provider.dart';   // <-- ADD THIS
import 'package:gamelog/widgets/game_card.dart';

// Change to a ConsumerWidget
class GameListView extends ConsumerWidget { // <-- MODIFY THIS
  final List<Game> games;

  const GameListView({
    super.key,
    required this.games,
  });

  @override
  // Add WidgetRef ref to the build method
  Widget build(BuildContext context, WidgetRef ref) { // <-- MODIFY THIS
    if (games.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.gamepad_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Your backlog is empty!',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Tap the + button to add a game.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: games.length,
      itemBuilder: (context, index) {
        final game = games[index];

        // --- WRAP GameCard WITH Dismissible ---
        return Dismissible(
          // A Key is crucial. It lets Flutter know which item is which.
          key: ValueKey(game.key),

          // The background that is revealed when swiping.
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20.0),
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: const Icon(Icons.delete, color: Colors.white),
          ),

          // The direction the user can swipe.
          direction: DismissDirection.endToStart, // Only allow swiping from right to left

          // This function is called when the item has been fully swiped away.
          onDismissed: (direction) {
            // Call the deleteGame method from our provider.
            ref.read(gameProvider.notifier).deleteGame(game);

            // Optionally, show a temporary "Undo" message.
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${game.title} deleted'),
                // We could add an "Undo" button here in the future.
              ),
            );
          },

          // The actual widget to display.
          child: GameCard(game: game),
        );
        // --- END OF Dismissible WRAPPER ---
      },
    );
  }
}