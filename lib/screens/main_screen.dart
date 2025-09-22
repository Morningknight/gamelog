import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamelog/screens/add_edit_game_screen.dart';
import 'package:gamelog/screens/archive_screen.dart'; // <-- ADD THIS IMPORT
import 'package:gamelog/screens/backlog_screen.dart'; // <-- ADD THIS IMPORT
import 'package:gamelog/screens/home_screen.dart';
import 'package:gamelog/screens/profile_screen.dart';

// The mainScreenIndexProvider remains the same
final mainScreenIndexProvider = StateProvider<int>((ref) => 0);

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(mainScreenIndexProvider);

    // --- REPLACE PLACEHOLDERS WITH REAL SCREENS ---
    final List<Widget> screens = [
      const HomeScreen(),      // Index 0: Now Playing
      const BacklogScreen(),   // Index 1: Backlog
      const ArchiveScreen(),   // Index 2: Archive
      const ProfileScreen(),     // Index 3: Profile
    ];

    // Determine which FAB to show based on the current screen
    Widget? floatingActionButton;
    if (selectedIndex == 0 || selectedIndex == 1) { // Show on Now Playing & Backlog
      floatingActionButton = FloatingActionButton(
        onPressed: () {
          // The FAB should add a game to the correct list.
          // For now, it opens a generic add screen. This can be refined later.
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => const AddEditGameScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      );
    }

    return Scaffold(
      body: screens[selectedIndex],

      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildNavItem(context, ref, icon: Icons.gamepad_outlined, index: 0, label: 'Now Playing'),
            _buildNavItem(context, ref, icon: Icons.calendar_today_outlined, index: 1, label: 'Backlog'),
            const SizedBox(width: 40), // The space for the FAB
            _buildNavItem(context, ref, icon: Icons.archive_outlined, index: 2, label: 'Archive'),
            _buildNavItem(context, ref, icon: Icons.person_outline, index: 3, label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, WidgetRef ref, {required IconData icon, required int index, required String label}) {
    final isSelected = ref.watch(mainScreenIndexProvider) == index;
    final color = isSelected ? Theme.of(context).colorScheme.primary : Colors.grey;

    return Tooltip(
      message: label,
      child: IconButton(
        icon: Icon(icon, color: color),
        onPressed: () {
          ref.read(mainScreenIndexProvider.notifier).state = index;
        },
      ),
    );
  }
}