import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamelog/models/game.dart';
import 'package:hive_flutter/hive_flutter.dart'; // <-- THIS IS THE CORRECTED LINE

// This class will be responsible for all logic related to the games box.
class GameNotifier extends StateNotifier<List<Game>> {
  // We initialize the notifier with the current list of games from the database.
  GameNotifier() : super(Hive.box<Game>('games').values.toList());

  // A direct reference to the box to avoid calling Hive.box multiple times.
  final _gameBox = Hive.box<Game>('games');

  // Method to add a new game
  void addGame(Game game) {
    _gameBox.add(game); // Add the new game to the Hive box

    // After adding, we update the state.
    // The state is the list of games. We read the latest list from the box.
    // Any widget listening to this provider will rebuild.
    state = _gameBox.values.toList();
  }

  // Method to delete a game
  void deleteGame(Game game) {
    // The 'delete' method is a special function provided by Hive when we extend HiveObject.
    // It finds the object in the box and removes it.
    game.delete();

    // Update the state to trigger a UI rebuild with the game removed.
    state = _gameBox.values.toList();
  }
}

// This is our actual provider.
// It's a global variable that we can use to access the GameNotifier from anywhere in our app.
final gameProvider = StateNotifierProvider<GameNotifier, List<Game>>((ref) {
  return GameNotifier();
});