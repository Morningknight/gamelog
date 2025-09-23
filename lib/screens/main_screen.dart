import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamelog/models/game.dart';
import 'package:gamelog/screens/add_edit_game_screen.dart';
import 'package:gamelog/screens/archive_screen.dart';
import 'package:gamelog/screens/backlog_screen.dart';
import 'package:gamelog/screens/home_screen.dart'; // This is our "Now Playing" screen
import 'package:gamelog/screens/profile_screen.dart';

// Default to index 2 (Now Playing).
final mainScreenIndexProvider = StateProvider<int>((ref) => 2);

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

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
                  Navigator.pop(ctx);
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
      Container(color: Colors.teal, child: const Center(child: Text('Gamer Tag'))), // Index 0
      const BacklogScreen(),                  // Index 1
      const HomeScreen(),                     // Index 2 (Now Playing)
      const ArchiveScreen(),                  // Index 3
      const ProfileScreen(),                  // Index 4
    ];

    // Show the FAB on all screens except the Profile screen (index 4)
    final fabVisible = selectedIndex < 4;

    return Scaffold(
      body: screens[selectedIndex],

      floatingActionButton: fabVisible
          ? FloatingActionButton(
        onPressed: () => _showAddGameMenu(context),
        child: const Icon(Icons.add),
      )
          : null,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          ref.read(mainScreenIndexProvider.notifier).state = index;
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.style_outlined), label: 'Gamer Tag'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), label: 'Backlog'),
          BottomNavigationBarItem(icon: Icon(Icons.gamepad_outlined), label: 'Now Playing'),
          BottomNavigationBarItem(icon: Icon(Icons.archive_outlined), label: 'Archive'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}