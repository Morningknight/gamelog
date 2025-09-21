import 'package:flutter/material.dart';
import 'package:gamelog/models/game.dart';

class GameCard extends StatelessWidget {
  final Game game;
  final VoidCallback onLongPress;

  const GameCard({
    super.key,
    required this.game,
    required this.onLongPress,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'now playing':
        return Colors.blueAccent;
      case 'beaten':
        return Colors.green;
      case 'paused':
        return Colors.orange;
      case 'not started':
      case 'dropped':
        return Colors.grey.shade600;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      // --- COLOR RESTORED ---
      // We are back to using the nice dark grey from our app's theme.
      color: Theme.of(context).colorScheme.surface,
      // --- END OF CHANGE ---
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onLongPress: onLongPress,
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
                    game.status,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: _getStatusColor(game.status),
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}