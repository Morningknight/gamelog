import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamelog/models/game.dart';
import 'package:hive_flutter/hive_flutter.dart';

// This class will be responsible for all logic related to the games box.
class GameNotifier extends StateNotifier<List<Game>> {
  // We initialize the notifier with the current list of games from the database.
  GameNotifier() : super(Hive.box<Game>('games').values.toList());

  // Method to add a new game
  void addGame(Game game) {
    final box = Hive.box<Game>('games');
    box.add(game); // Add the new game to the Hive box

    // After adding, we update the state.
    // The state is the list of games. We read the latest list from the box.
    // Any widget listening to this provider will rebuild.
    state = box.values.toList();
  }

  // Method to delete a game
  void deleteGame(Game game) {
    game.delete(); // The 'delete' method comes from extending HiveObject

    // Update the state to trigger a UI rebuild
    state = Hive.box<Game>('games').values.toList();
  }

// Method to update an existing game could be added here later.
}

// This is our actual provider.
// It's a global variable that we can use to access the GameNotifier from anywhere in our app.
final gameProvider = StateNotifierProvider<GameNotifier, List<Game>>((ref) {
  return GameNotifier();
});