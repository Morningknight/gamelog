import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamelog/models/game.dart';
import 'package:gamelog/screens/add_edit_game_screen.dart';
import 'package:gamelog/screens/archive_screen.dart';
import 'package:gamelog/screens/backlog_screen.dart';
import 'package:gamelog/screens/home_screen.dart';
import 'package:gamelog/screens/profile_screen.dart';
import 'package:gamelog/screens/support_screen.dart'; // Import for dialog button
import 'package:shared_preferences/shared_preferences.dart'; // Import for checking date

final mainScreenIndexProvider = StateProvider<int>((ref) => 0);

// --- CONVERT TO CONSUMER STATEFUL WIDGET ---
class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  // --- ADD INITSTATE AND POPUP LOGIC ---
  @override
  void initState() {
    super.initState();
    // Use WidgetsBinding to ensure the build is complete before showing a dialog
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForMonthlyPopup();
    });
  }

  Future<void> _checkForMonthlyPopup() async {
    final prefs = await SharedPreferences.getInstance();
    // Try to get the last date the popup was shown
    final lastPopupDateString = prefs.getString('lastSupportPopupDate');

    if (lastPopupDateString != null) {
      final lastPopupDate = DateTime.parse(lastPopupDateString);
      // If it has been less than 30 days, do nothing.
      if (DateTime.now().difference(lastPopupDate).inDays < 30) {
        return;
      }
    }

    // If we're here, it's either the first time or 30 days have passed.
    // So, show the dialog.
    if (mounted) {
      _showSupportDialog(context);
    }
  }

  void _showSupportDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Enjoying GameLog?'),
        content: const Text('A lot of love goes into developing this app. If you find it useful, please consider supporting its future.'),
        actions: [
          TextButton(
            child: const Text('Maybe Later'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          FilledButton(
            child: const Text('Support Us'),
            onPressed: () {
              Navigator.of(ctx).pop(); // Close the dialog first
              // Then navigate to the support screen
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SupportScreen()),
              );
            },
          ),
        ],
      ),
    );

    // After showing the dialog, save the current time.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastSupportPopupDate', DateTime.now().toIso8601String());
  }
  // --- END OF NEW LOGIC ---

  void _showAddGameMenu(BuildContext context) {
    // ... (This function remains unchanged)
  }

  @override
  Widget build(BuildContext context) {
    // In a ConsumerStatefulWidget, 'ref' is a property of the state class.
    final selectedIndex = ref.watch(mainScreenIndexProvider);

    final List<Widget> screens = [
      const HomeScreen(),
      const BacklogScreen(),
      const ArchiveScreen(),
      const ProfileScreen(),
    ];

    final fabVisible = selectedIndex < 3;

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