import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamelog/models/game.dart';
import 'package:gamelog/screens/add_edit_game_screen.dart';
import 'package:gamelog/screens/archive_screen.dart';
import 'package:gamelog/screens/backlog_screen.dart';
import 'package:gamelog/screens/home_screen.dart';
import 'package:gamelog/screens/profile_screen.dart';

// Default to index 0 (Now Playing).
final mainScreenIndexProvider = StateProvider<int>((ref) => 0);

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  // Logic to show the FAB menu
  void _showAddGameMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.playlist_add),
                title: const Text('Add to Backlog'),
                onTap: () {
                  Navigator.pop(ctx); // Close the sheet
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const AddEditGameScreen(defaultStatus: GameStatus.backlog),
                  ));
                },
              ),
              ListTile(
                leading: const Icon(Icons.play_circle_outline),
                title: const Text('Add to Now Playing'),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const AddEditGameScreen(defaultStatus: GameStatus.nowPlaying),
                  ));
                },
              ),
              ListTile(
                leading: const Icon(Icons.archive_outlined),
                title: const Text('Add to Archive'),
                subtitle: const Text('For a game you already beat'),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const AddEditGameScreen(defaultStatus: GameStatus.beaten),
                  ));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(mainScreenIndexProvider);

    final List<Widget> screens = [
      const HomeScreen(),      // Index 0: Now Playing
      const BacklogScreen(),   // Index 1: Backlog
      const ArchiveScreen(),   // Index 2: Archive
      const ProfileScreen(),     // Index 3: Profile
    ];

    // Show the FAB on all screens except the Profile screen
    final fabVisible = selectedIndex < 3;

    return Scaffold(
      body: screens[selectedIndex],

      floatingActionButton: fabVisible ? FloatingActionButton(
        onPressed: () => _showAddGameMenu(context),
        child: const Icon(Icons.add),
      ) : null,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          ref.read(mainScreenIndexProvider.notifier).state = index;
        },
        type: BottomNavigationBarType.fixed,
        // Use theme colors for a more integrated look
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.gamepad_outlined), label: 'Now Playing'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), label: 'Backlog'),
          BottomNavigationBarItem(icon: Icon(Icons.archive_outlined), label: 'Archive'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}