import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamelog/models/game.dart';
import 'package:hive_flutter/hive_flutter.dart';

// This provider holds the master list of ALL games.
final gameListProvider = StateNotifierProvider<GameNotifier, List<Game>>((ref) {
  return GameNotifier();
});

// A computed provider for the "Now Playing" screen.
// It returns only active (non-archived) games.
final nowPlayingProvider = Provider<List<Game>>((ref) {
  final allGames = ref.watch(gameListProvider);
  return allGames.where((game) =>
  game.status == GameStatus.nowPlaying ||
      game.status == GameStatus.paused ||
      game.status == GameStatus.notStarted
  ).toList();
});

// A computed provider for the "Archive" screen.
// It returns games that are beaten or dropped.
final archiveProvider = Provider<List<Game>>((ref) {
  final allGames = ref.watch(gameListProvider);
  return allGames.where((game) =>
  game.status == GameStatus.beaten ||
      game.status == GameStatus.dropped
  ).toList();
});

// A computed provider for the "Backlog" screen.
final backlogProvider = Provider<List<Game>>((ref) {
  final allGames = ref.watch(gameListProvider);
  return allGames.where((game) => game.status == GameStatus.backlog).toList();
});


class GameNotifier extends StateNotifier<List<Game>> {
  GameNotifier() : super(Hive.box<Game>('games').values.toList());
  final _gameBox = Hive.box<Game>('games');

  void _refreshGames() {
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

  void updateGame(Game updatedGame) {
    // The updatedGame object is already linked to the Hive instance,
    // so we just need to save it.
    updatedGame.save();
    _refreshGames();
  }

  void archiveGame(Game game) {
    // Archiving now means setting the status to 'beaten'
    game.status = GameStatus.beaten;
    game.save();
    _refreshGames();
  }
}