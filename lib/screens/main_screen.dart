import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamelog/models/game.dart';
import 'package:gamelog/screens/add_edit_game_screen.dart';
import 'package:gamelog/screens/archive_screen.dart';
import 'package:gamelog/screens/backlog_screen.dart';
import 'package:gamelog/screens/home_screen.dart';
import 'package:gamelog/screens/profile_screen.dart';
import 'package:gamelog/screens/support_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

final mainScreenIndexProvider = StateProvider<int>((ref) => 0);

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleAppStartupLogic();
    });
  }

  // --- NEW, SMARTER STARTUP LOGIC ---
  Future<void> _handleAppStartupLogic() async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Increment and get the app open count.
    int appOpenCount = prefs.getInt('appOpenCount') ?? 0;
    appOpenCount++;
    await prefs.setInt('appOpenCount', appOpenCount);

    // 2. Check if the user is new (opened the app less than 5 times).
    if (appOpenCount < 5) {
      return; // Do not show the popup for new users.
    }

    // 3. If the user is not new, proceed with the monthly check.
    final lastPopupDateString = prefs.getString('lastSupportPopupDate');
    if (lastPopupDateString != null) {
      final lastPopupDate = DateTime.parse(lastPopupDateString);
      if (DateTime.now().difference(lastPopupDate).inDays < 30) {
        return; // It's been less than 30 days, so do nothing.
      }
    }

    // 4. If we're here, it's time to show the dialog.
    if (mounted) {
      _showSupportDialog(context);
    }
  }

  // --- UPDATED DIALOG WITH NEW TEXT ---
  void _showSupportDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Enjoying GameLog?'),
        content: const Text(
          "GameLog is proudly ad-free, and that's thanks to support from users like you.\n\nEvery January, 10% of all support received is donated to charity. Your contribution makes a real difference!",
        ),
        actions: [
          TextButton(
            child: const Text('Maybe Later'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          FilledButton(
            child: const Text('Support Us'),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SupportScreen()),
              );
            },
          ),
        ],
      ),
    );

    // Always save the current time after showing the dialog to reset the timer.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastSupportPopupDate', DateTime.now().toIso8601String());
  }

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
  Widget build(BuildContext context) {
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
        onTap: (index) => ref.read(mainScreenIndexProvider.notifier).state = index,
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