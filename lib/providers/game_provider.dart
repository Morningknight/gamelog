import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamelog/models/game.dart';
import 'package:hive_flutter/hive_flutter.dart';

// --- ADD THIS ENUM ---
// Using an enum is safer than using raw Strings for our filter types.
enum GameFilter { all, nowPlaying, beaten, notStarted, paused, dropped }
// --- END OF ENUM ---

// --- ADD THIS NEW PROVIDER ---
// This provider will simply hold the current filter state.
final gameFilterProvider = StateProvider<GameFilter>((ref) => GameFilter.all);
// --- END OF NEW PROVIDER ---

class GameNotifier extends StateNotifier<List<Game>> {
  GameNotifier() : super(Hive.box<Game>('games').values.toList());
  final _gameBox = Hive.box<Game>('games');

  void _refreshGames() {
    // A helper function to avoid repeating code
    state = _gameBox.values.toList();
  }

  void addGame(Game game) {
    _gameBox.add(game);
    _refreshGames();
  }

  void deleteGame(Game game) {
    game.delete();
    _refreshGames();
  }

  void updateGame(Game existingGame, Game updatedGameData) {
    existingGame.title = updatedGameData.title;
    existingGame.platform = updatedGameData.platform;
    existingGame.genre = updatedGameData.genre;
    existingGame.status = updatedGameData.status;
    existingGame.save();
    _refreshGames();
  }
}

// --- MODIFY THE EXISTING gameProvider ---
// We will change this to a regular Provider that DEPENDS on our other providers.
final gameProvider = Provider<List<Game>>((ref) {
  // Watch both the game list and the current filter.
  final filter = ref.watch(gameFilterProvider);
  final games = ref.watch(gameListProvider); // Changed from gameProvider

  // Based on the filter, return the appropriate list of games.
  switch (filter) {
    case GameFilter.nowPlaying:
      return games.where((game) => game.status == 'Now Playing').toList();
    case GameFilter.beaten:
      return games.where((game) => game.status == 'Beaten').toList();
    case GameFilter.notStarted:
      return games.where((game) => game.status == 'Not Started').toList();
    case GameFilter.paused:
      return games.where((game) => game.status == 'Paused').toList();
    case GameFilter.dropped:
      return games.where((game) => game.status == 'Dropped').toList();
    case GameFilter.all:
      return games;
  }
});

// Rename the old provider to gameListProvider
final gameListProvider = StateNotifierProvider<GameNotifier, List<Game>>((ref) {
  return GameNotifier();
});