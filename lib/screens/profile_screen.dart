import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamelog/widgets/profile_menu_widgets.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          // --- User Avatar and Name ---
          const CircleAvatar(
            radius: 50,
            // In a real app, this would be a user's image.
            // For now, a placeholder icon is fine.
            child: Icon(Icons.person, size: 50),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'Martha Hays', // We will make this editable later
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),

          // --- Game Stats ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatChip('10 Games Left', context),
              _buildStatChip('5 Games Done', context),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),

          // --- Menu List ---
          const SectionTitle(title: 'Settings'),
          ProfileMenuItem(
            icon: Icons.settings,
            title: 'App Settings',
            onTap: () {
              // TODO: Navigate to App Settings screen
              print('App Settings Tapped');
            },
          ),
          const SectionTitle(title: 'Account'),
          ProfileMenuItem(
            icon: Icons.person_outline,
            title: 'Change account name',
            onTap: () {
              // TODO: Show dialog to change name
              print('Change Name Tapped');
            },
          ),
          // For now, we'll keep the password/image options simple
          // as they require more complex logic.
          const SectionTitle(title: 'Uptodo'), // Changed to GameLog
          ProfileMenuItem(
            icon: Icons.info_outline,
            title: 'About Us',
            onTap: () {
              // TODO: Navigate to About screen
              print('About Us Tapped');
            },
          ),
          ProfileMenuItem(
            icon: Icons.help_outline,
            title: 'Help & Feedback',
            onTap: () {
              // TODO: Launch URL for feedback
              print('Help & Feedback Tapped');
            },
          ),
          ProfileMenuItem(
            icon: Icons.favorite_border,
            title: 'Support Us',
            onTap: () {
              // TODO: Launch Buy Me a Coffee URL
              print('Support Us Tapped');
            },
          ),
          ProfileMenuItem(
            icon: Icons.logout,
            title: 'Log out',
            textColor: Colors.red, // Example of using the optional color
            onTap: () {
              // TODO: Implement logout logic
              print('Log Out Tapped');
            },
          ),
        ],
      ),
    );
  }

  // Helper widget for the "X Games Left/Done" chips
  Widget _buildStatChip(String label, BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    );
  }
}