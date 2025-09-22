import 'package:flutter/material.dart';
import 'package:gamelog/models/game.dart';

class GameCard extends StatelessWidget {
  final Game game;

  const GameCard({
    super.key,
    required this.game,
  });

  // Helper function to get a color based on the GameStatus enum.
  Color _getStatusColor(GameStatus status) {
    switch (status) {
      case GameStatus.nowPlaying:
        return Colors.blueAccent;
      case GameStatus.beaten:
        return Colors.green;
      case GameStatus.paused:
        return Colors.orange;
      case GameStatus.notStarted:
      case GameStatus.dropped:
      case GameStatus.backlog:
      // Added a default case for safety
        return Colors.grey.shade600;
    }
  }

  // Helper function to get a display-friendly string from the GameStatus enum.
  String _getStatusText(GameStatus status) {
    switch (status) {
      case GameStatus.nowPlaying:
        return 'Now Playing';
      case GameStatus.notStarted:
        return 'Not Started';
      case GameStatus.beaten:
        return 'Beaten';
      case GameStatus.paused:
        return 'Paused';
      case GameStatus.dropped:
        return 'Dropped';
      case GameStatus.backlog:
        return 'Backlog';
      }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: Theme.of(context).colorScheme.surface,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      // The InkWell is removed as the gestures are now handled by Dismissible.
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              game.title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Chip(
                  label: Text(game.platform),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                ),
                const SizedBox(width: 8.0),
                Chip(
                  label: Text(game.genre),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Align(
              alignment: Alignment.centerRight,
              child: Chip(
                label: Text(
                  _getStatusText(game.status), // Use the helper for display text
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: _getStatusColor(game.status), // Use the helper for color
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}