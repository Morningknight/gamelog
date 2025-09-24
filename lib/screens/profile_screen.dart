import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamelog/providers/game_provider.dart';
import 'package:gamelog/providers/user_settings_provider.dart';
import 'package:gamelog/screens/about_screen.dart';
import 'package:gamelog/screens/app_settings_screen.dart';
import 'package:gamelog/screens/support_screen.dart';
import 'package:gamelog/widgets/profile_menu_widgets.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  // --- HELPER METHODS MOVED INSIDE THE CLASS ---
  void _showChangeNameDialog(BuildContext context, WidgetRef ref) {
    final settingsService = ref.read(userSettingsServiceProvider);
    final nameController = TextEditingController(text: settingsService.getUserName());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Change Account Name'),
        content: TextField(
          controller: nameController,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'New Name'),
        ),
        actions: [
          TextButton(child: const Text('Cancel'), onPressed: () => Navigator.of(ctx).pop()),
          ElevatedButton(
            child: const Text('Save'),
            onPressed: () {
              final newName = nameController.text;
              if (newName.isNotEmpty) {
                settingsService.setUserName(newName);
                ref.invalidate(userNameProvider);
                Navigator.of(ctx).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTotalGamesStat(int count, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.collections_bookmark, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Text(
            'Total Games Added: $count',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
  // --- END OF MOVED METHODS ---

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = ref.watch(userNameProvider);
    final totalGames = ref.watch(gameListProvider).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
          const SizedBox(height: 12),
          Center(
            child: Text(
              userName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          _buildTotalGamesStat(totalGames, context),
          const SizedBox(height: 20),
          const Divider(),
          const SectionTitle(title: 'Settings'),
          ProfileMenuItem(
            icon: Icons.settings_outlined,
            title: 'App Settings',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const AppSettingsScreen()),
              );
            },
          ),
          const SectionTitle(title: 'Account'),
          ProfileMenuItem(
            icon: Icons.person_outline,
            title: 'Change account name',
            onTap: () => _showChangeNameDialog(context, ref),
          ),
          const SectionTitle(title: 'GameLog'),
          ProfileMenuItem(
            icon: Icons.info_outline,
            title: 'About GameLog',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const AboutScreen()),
              );
            },
          ),
          ProfileMenuItem(
            icon: Icons.favorite_border,
            title: 'Support & Charity',
            onTap: () {
              // --- CORRECTED TYPO: 'container' to 'context' ---
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const SupportScreen()),
              );
            },
          ),
          const Divider(),
          ProfileMenuItem(
            icon: Icons.logout,
            title: 'Log out',
            textColor: Colors.red,
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Log Out'),
                  content: const Text('This is a placeholder for the logout feature.'),
                  actions: [TextButton(child: const Text('OK'), onPressed: () => Navigator.of(ctx).pop())],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}