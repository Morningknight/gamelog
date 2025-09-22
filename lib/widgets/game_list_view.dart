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
      // This empty state might need context-specific text later
      return const Center(child: Text("No games in this list yet!"));
    }

    return ListView.builder(
      itemCount: games.length,
      itemBuilder: (context, index) {
        final game = games[index];

        return Dismissible(
          key: ValueKey(game.key),

          // Background for SWIPE RIGHT (Archive)
          background: Container(
            color: Colors.green, // A more positive color for archiving
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20.0),
            child: const Icon(Icons.archive, color: Colors.white),
          ),

          // Background for SWIPE LEFT (Edit)
          secondaryBackground: Container(
            color: Colors.blue, // A neutral color for editing
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20.0),
            child: const Icon(Icons.edit, color: Colors.white),
          ),

          // This function is called BEFORE the swipe animation completes.
          // It returns a Future<bool> to confirm if the dismissal should happen.
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.startToEnd) {
              // Swiped Right (Archive)
              ref.read(gameListProvider.notifier).archiveGame(game);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${game.title} archived')),
              );
              return true; // The item will be removed from this list.
            } else {
              // Swiped Left (Edit)
              // We open the edit screen. We do NOT want to dismiss the item.
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => AddEditGameScreen(game: game),
                ),
              );
              return false; // The item will slide back into place.
            }
          },

          // We removed onDismissed and now use confirmDismiss.

          // The GameCard no longer needs a long-press gesture.
          child: GameCard(game: game),
        );
      },
    );
  }
}