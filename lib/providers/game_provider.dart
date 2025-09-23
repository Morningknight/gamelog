import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamelog/models/game.dart';
import 'package:hive_flutter/hive_flutter.dart';

// This provider holds the master list of ALL games from the database.
final gameListProvider = StateNotifierProvider<GameNotifier, List<Game>>((ref) {
  return GameNotifier();
});

// "Now Playing" is ONLY for games with the 'nowPlaying' status.
final nowPlayingProvider = Provider<List<Game>>((ref) {
  final allGames = ref.watch(gameListProvider);
  return allGames.where((game) => game.status == GameStatus.nowPlaying).toList();
});

// "Archive" is ONLY for games with the 'beaten' status.
final archiveProvider = Provider<List<Game>>((ref) {
  final allGames = ref.watch(gameListProvider);
  return allGames.where((game) => game.status == GameStatus.beaten).toList();
});

// "Backlog" is for 'backlog', 'paused', 'dropped', and 'notStarted' statuses.
final backlogProvider = Provider<List<Game>>((ref) {
  final allGames = ref.watch(gameListProvider);
  return allGames.where((game) =>
  game.status == GameStatus.backlog ||
      game.status == GameStatus.paused ||
      game.status == GameStatus.dropped ||
      game.status == GameStatus.notStarted
  ).toList();
});

class GameNotifier extends StateNotifier<List<Game>> {
  GameNotifier() : super(Hive.box<Game>('games').values.toList());
  final _gameBox = Hive.box<Game>('games');

  void refreshGames() {
    state = _gameBox.values.toList();
  }

  void addGame(Game game) {
    _gameBox.add(game);
    refreshGames();
  }

  void deleteGame(Game game) {
    game.delete();
    refreshGames();
  }

  void updateGame(Game updatedGame) {
    updatedGame.save();
    refreshGames();
  }

  // --- ADD THIS METHOD BACK ---
  void archiveGame(Game game) {
    // Archiving now means setting the status to 'beaten' by default
    game.status = GameStatus.beaten;
    game.save();
    refreshGames();
  }
// --- END OF ADDED METHOD ---
}