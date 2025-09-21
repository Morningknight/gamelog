import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamelog/screens/add_edit_game_screen.dart';
import 'package:gamelog/screens/home_screen.dart';
import 'package:gamelog/screens/profile_screen.dart'; // <-- ADD THIS IMPORT

// A simple provider to hold the state of the selected tab index.
final mainScreenIndexProvider = StateProvider<int>((ref) => 0);

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(mainScreenIndexProvider);

    // List of the main screens in our app.
    final List<Widget> screens = [
      const HomeScreen(),
      Container(color: Colors.blue, child: const Center(child: Text('Calendar'))), // Placeholder
      Container(color: Colors.green, child: const Center(child: Text('Focus'))), // Placeholder
      const ProfileScreen(), // <-- REPLACE THE RED CONTAINER
    ];

    final fab = FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => const AddEditGameScreen(),
          ),
        );
      },
      child: const Icon(Icons.add),
    );

    return Scaffold(
      body: screens[selectedIndex],

      floatingActionButton: selectedIndex == 0 ? fab : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildNavItem(context, ref, icon: Icons.home_filled, index: 0, label: 'Index'),
            _buildNavItem(context, ref, icon: Icons.calendar_today, index: 1, label: 'Calendar'),
            const SizedBox(width: 40),
            _buildNavItem(context, ref, icon: Icons.timer, index: 2, label: 'Focus'),
            _buildNavItem(context, ref, icon: Icons.person, index: 3, label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, WidgetRef ref, {required IconData icon, required int index, required String label}) {
    final isSelected = ref.watch(mainScreenIndexProvider) == index;
    final color = isSelected ? Theme.of(context).colorScheme.primary : Colors.grey;

    return IconButton(
      icon: Icon(icon, color: color),
      onPressed: () {
        ref.read(mainScreenIndexProvider.notifier).state = index;
      },
      tooltip: label,
    );
  }
}