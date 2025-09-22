import 'package:hive/hive.dart';

part 'game.g.dart'; // This will be regenerated

// --- NEW ENUM FOR STATUS ---
// By using a HiveType with an enum, Hive can store it efficiently.
@HiveType(typeId: 1) // IMPORTANT: Use a new, unique typeId (we used 0 for Game)
enum GameStatus {
  @HiveField(0)
  backlog, // Game is in the user's wishlist/backlog

  @HiveField(1)
  notStarted, // Game is installed, on the "Now Playing" list

  @HiveField(2)
  nowPlaying, // Actively being played

  @HiveField(3)
  paused, // Paused on the "Now Playing" list

  @HiveField(4)
  beaten, // Finished, belongs in the Archive

  @HiveField(5)
  dropped, // Abandoned, belongs in the Archive
}

@HiveType(typeId: 0)
class Game extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String platform;

  @HiveField(2)
  String genre;

  @HiveField(3) // This field number is now reused for our new enum
  GameStatus status;

  @HiveField(4)
  DateTime dateAdded;

  // The isArchived field (5) is no longer needed.

  Game({
    required this.title,
    required this.platform,
    required this.genre,
    required this.status,
    required this.dateAdded,
  });
}