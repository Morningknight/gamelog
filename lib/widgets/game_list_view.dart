import 'package:flutter/material.dart';
import 'package:gamelog/models/game.dart';
import 'package:gamelog/widgets/game_card.dart';

class GameListView extends StatelessWidget {
  final List<Game> games;

  const GameListView({
    super.key,
    required this.games,
  });

  @override
  Widget build(BuildContext context) {
    // If the list of games is empty, show a helpful message.
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

    // If there are games, display them in an efficient, scrollable list.
    return ListView.builder(
      // The number of items in the list.
      itemCount: games.length,
      // A function that builds each item in the list.
      // It's efficient because it only builds the items visible on screen.
      itemBuilder: (context, index) {
        final game = games[index];
        return GameCard(game: game);
      },
    );
  }
}