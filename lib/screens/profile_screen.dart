import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamelog/providers/user_settings_provider.dart';
import 'package:gamelog/screens/app_settings_screen.dart';
import 'package:gamelog/widgets/profile_menu_widgets.dart';

// NO provider definitions should be in this file.

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

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
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = ref.watch(userNameProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 50,
            child: Icon(Icons.person, size: 50),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              userName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatChip('10 Games Left', context),
              _buildStatChip('5 Games Done', context),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SectionTitle(title: 'Settings'),
          ProfileMenuItem(
            icon: Icons.settings,
            title: 'App Settings',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const AppSettingsScreen(),
                ),
              );
            },
          ),
          const SectionTitle(title: 'Account'),
          ProfileMenuItem(
            icon: Icons.person_outline,
            title: 'Change account name',
            onTap: () {
              _showChangeNameDialog(context, ref);
            },
          ),
          const SectionTitle(title: 'GameLog'),
          ProfileMenuItem(
            icon: Icons.info_outline,
            title: 'About Us',
            onTap: () { /* ... */ },
          ),
          ProfileMenuItem(
            icon: Icons.help_outline,
            title: 'Help & Feedback',
            onTap: () { /* ... */ },
          ),
          ProfileMenuItem(
            icon: Icons.favorite_border,
            title: 'Support Us',
            onTap: () { /* ... */ },
          ),
          ProfileMenuItem(
            icon: Icons.logout,
            title: 'Log out',
            textColor: Colors.red,
            onTap: () { /* ... */ },
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    );
  }
}