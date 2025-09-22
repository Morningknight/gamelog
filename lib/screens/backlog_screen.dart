import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamelog/models/game.dart';
import 'package:gamelog/providers/game_provider.dart';
import 'package:gamelog/widgets/game_card.dart';

class BacklogScreen extends ConsumerWidget {
  const BacklogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch our new provider for backlog games
    final List<Game> games = ref.watch(backlogProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Backlog'),
      ),
      body: ListView.builder(
        itemCount: games.length,
        itemBuilder: (context, index) {
          final game = games[index];
          return Card(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: InkWell(
              onTap: () {
                // Tapping a backlog item could show an edit screen in the future
              },
              child: Stack(
                children: [
                  // We reuse the GameCard for consistent looks
                  GameCard(game: game),
                  // Add an overlay button to move the game to the active list
                  Positioned(
                    bottom: 8,
                    left: 16,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add_to_home_screen, size: 16),
                      label: const Text('Move to Now Playing'),
                      onPressed: () {
                        // Update the game's status
                        game.status = GameStatus.notStarted;
                        ref.read(gameListProvider.notifier).updateGame(game);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${game.title} moved to Now Playing')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        textStyle: const TextStyle(fontSize: 12),
                        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}