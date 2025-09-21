import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamelog/models/game.dart';
import 'package:gamelog/providers/game_provider.dart';

class AddEditGameScreen extends ConsumerStatefulWidget {
  final Game? game;
  const AddEditGameScreen({super.key, this.game});

  @override
  ConsumerState<AddEditGameScreen> createState() => _AddEditGameScreenState();
}

class _AddEditGameScreenState extends ConsumerState<AddEditGameScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _platformController = TextEditingController();
  final _genreController = TextEditingController();
  String? _selectedStatus;
  final List<String> _statuses = ['Not Started', 'Now Playing', 'Paused', 'Beaten', 'Dropped'];

  @override
  void initState() {
    super.initState();
    if (widget.game != null) {
      _titleController.text = widget.game!.title;
      _platformController.text = widget.game!.platform;
      _genreController.text = widget.game!.genre;
      _selectedStatus = widget.game!.status;
    } else {
      _selectedStatus = 'Not Started';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _platformController.dispose();
    _genreController.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid || _selectedStatus == null) {
      return;
    }

    final gameData = Game(
      title: _titleController.text,
      platform: _platformController.text,
      genre: _genreController.text,
      status: _selectedStatus!,
      dateAdded: widget.game?.dateAdded ?? DateTime.now(),
    );

    if (widget.game != null) {
      // Use gameListProvider to call the update method
      ref.read(gameListProvider.notifier).updateGame(widget.game!, gameData);
    } else {
      // Use gameListProvider to call the add method
      ref.read(gameListProvider.notifier).addGame(gameData);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.game != null;
    final appBarTitle = isEditing ? 'Edit Game' : 'Add New Game';

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
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
                initialValue: _selectedStatus,
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