import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // <-- ADD THIS
import 'package:gamelog/models/game.dart'; // <-- ADD THIS
import 'package:gamelog/providers/game_provider.dart'; // <-- ADD THIS

// Change to ConsumerStatefulWidget
class AddEditGameScreen extends ConsumerStatefulWidget { // <-- MODIFY THIS
  const AddEditGameScreen({super.key});

  @override
  // Change to ConsumerState
  ConsumerState<AddEditGameScreen> createState() => _AddEditGameScreenState(); // <-- MODIFY THIS
}

// Change to ConsumerState
class _AddEditGameScreenState extends ConsumerState<AddEditGameScreen> { // <-- MODIFY THIS
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _platformController = TextEditingController();
  final _genreController = TextEditingController();
  String? _selectedStatus = 'Not Started';
  final List<String> _statuses = ['Not Started', 'Now Playing', 'Paused', 'Beaten', 'Dropped'];

  @override
  void dispose() {
    _titleController.dispose();
    _platformController.dispose();
    _genreController.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    // --- UPDATE THIS PART ---
    final newGame = Game(
      title: _titleController.text,
      platform: _platformController.text,
      genre: _genreController.text,
      status: _selectedStatus!,
      dateAdded: DateTime.now(),
    );

    // Use the provider to add the game
    // ref.read tells us to "call a function" on the provider, not listen for changes.
    ref.read(gameProvider.notifier).addGame(newGame);

    Navigator.of(context).pop();
    // --- END OF UPDATE ---
  }

  @override
  Widget build(BuildContext context) {
    // ... no changes needed in the build method ...
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Game'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _platformController,
                decoration: const InputDecoration(labelText: 'Platform (e.g., PC, PS5)'),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a platform.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _genreController,
                decoration: const InputDecoration(labelText: 'Genre'),
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a genre.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(labelText: 'Status'),
                items: _statuses.map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedStatus = newValue;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}