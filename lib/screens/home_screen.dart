import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamelog/models/game.dart';
import 'package:gamelog/providers/game_provider.dart';
import 'package:gamelog/widgets/game_list_view.dart';
import 'package:gamelog/widgets/empty_state_widget.dart'; // <-- ADD THIS IMPORT

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Game> games = ref.watch(nowPlayingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
      ),
      // --- UPDATED BODY LOGIC ---
      body: games.isEmpty
          ? const EmptyStateWidget(
        icon: Icons.play_circle_outline,
        title: 'Nothing Here Yet',
        message: "Games you are actively playing will appear here. Add one from your backlog or using the '+' button.",
      )
          : GameListView(games: games), // We will need to update GameListView next
    );
  }
}