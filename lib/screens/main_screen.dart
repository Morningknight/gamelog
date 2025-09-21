import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamelog/screens/home_screen.dart'; // We will create this file next

// A simple provider to hold the state of the selected tab index.
final mainScreenIndexProvider = StateProvider<int>((ref) => 0);

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the provider to get the current index.
    final selectedIndex = ref.watch(mainScreenIndexProvider);

    // List of the main screens in our app.
    final List<Widget> screens = [
      const HomeScreen(),
      // TODO: Add other screens like Calendar, Focus, Profile here
      Container(color: Colors.blue, child: const Center(child: Text('Calendar'))), // Placeholder
      Container(color: Colors.green, child: const Center(child: Text('Focus'))), // Placeholder
      Container(color: Colors.red, child: const Center(child: Text('Profile'))), // Placeholder
    ];

    // The FloatingActionButton is now part of the main screen structure
    final fab = FloatingActionButton(
      onPressed: () {
        // TODO: This should navigate to the AddEditGameScreen
        print('FAB Pressed!');
      },
      child: const Icon(Icons.add),
    );

    return Scaffold(
      // The body changes based on the selected index from the bottom bar.
      body: screens[selectedIndex],

      floatingActionButton: fab,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(), // Creates the "dock" for the FAB
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildNavItem(context, ref, icon: Icons.home_filled, index: 0, label: 'Index'),
            _buildNavItem(context, ref, icon: Icons.calendar_today, index: 1, label: 'Calendar'),
            const SizedBox(width: 40), // The space for the FAB
            _buildNavItem(context, ref, icon: Icons.timer, index: 2, label: 'Focus'),
            _buildNavItem(context, ref, icon: Icons.person, index: 3, label: 'Profile'),
          ],
        ),
      ),
    );
  }

  // Helper method to build each navigation item to avoid code repetition.
  Widget _buildNavItem(BuildContext context, WidgetRef ref, {required IconData icon, required int index, required String label}) {
    final isSelected = ref.watch(mainScreenIndexProvider) == index;
    final color = isSelected ? Theme.of(context).colorScheme.primary : Colors.grey;

    return IconButton(
      icon: Icon(icon, color: color),
      onPressed: () {
        // When an item is tapped, update the state of the provider.
        ref.read(mainScreenIndexProvider.notifier).state = index;
      },
      tooltip: label,
    );
  }
}