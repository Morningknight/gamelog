import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamelog/models/game.dart';
import 'package:gamelog/providers/game_provider.dart';
import 'package:gamelog/screens/add_edit_game_screen.dart';
import 'package:gamelog/widgets/game_card.dart';

class BacklogScreen extends ConsumerWidget {
  const BacklogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Game> games = ref.watch(backlogProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Backlog'),
        // No actions button needed here anymore.
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
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => AddEditGameScreen(game: game)),
                );
              },
              child: Stack(
                children: [
                  GameCard(game: game),
                  Positioned(
                    bottom: 8,
                    left: 16,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.play_arrow, size: 16),
                      label: const Text('Start Playing'),
                      onPressed: () {
                        game.status = GameStatus.nowPlaying;
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