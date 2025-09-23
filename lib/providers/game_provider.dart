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

  void updateGameStatus(Game game, GameStatus newStatus) {
    game.status = newStatus;
    game.save();
    refreshGames();
  }
}

// --- NEW SEARCH PROVIDERS ---

// This provider will hold the current text being typed into the search bar.
final searchQueryProvider = StateProvider<String>((ref) => '');

// This is a computed provider that returns a filtered list of games
// based on the current search query.
// It searches across ALL games from the master list.
final searchResultsProvider = Provider<List<Game>>((ref) {
  final allGames = ref.watch(gameListProvider);
  final query = ref.watch(searchQueryProvider);

  // If the query is empty, return an empty list (don't show all games by default).
  if (query.trim().isEmpty) {
    return [];
  }

  // Filter the list, ignoring case.
  return allGames.where((game) {
    return game.title.toLowerCase().contains(query.toLowerCase());
  }).toList();
});