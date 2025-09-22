import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamelog/providers/user_settings_provider.dart';
import 'package:gamelog/screens/app_settings_screen.dart';
import 'package:gamelog/widgets/profile_menu_widgets.dart';

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
              userName, // Reads the name from the provider
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          // We can make these stats dynamic in a future step
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatChip('Games Left', context),
              _buildStatChip('Games Done', context),
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
              _showChangeNameDialog(context, ref); // Calls the dialog
            },
          ),
          // ... other menu items ...
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