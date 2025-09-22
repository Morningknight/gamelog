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

  // --- UPDATED STATUS LOGIC ---
  GameStatus? _selectedStatus; // Now holds a GameStatus object

  // Helper to get a display-friendly string from the enum
  String _getStatusText(GameStatus status) {
    switch (status) {
      case GameStatus.nowPlaying: return 'Now Playing';
      case GameStatus.notStarted: return 'Not Started';
      case GameStatus.beaten: return 'Beaten';
      case GameStatus.paused: return 'Paused';
      case GameStatus.dropped: return 'Dropped';
      case GameStatus.backlog: return 'Backlog';
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.game != null) {
      _titleController.text = widget.game!.title;
      _platformController.text = widget.game!.platform;
      _genreController.text = widget.game!.genre;
      _selectedStatus = widget.game!.status;
    } else {
      // Default to Backlog for a new game
      _selectedStatus = GameStatus.backlog;
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

    if (widget.game != null) {
      // We are in Edit Mode
      // Update the existing game object's properties
      widget.game!.title = _titleController.text;
      widget.game!.platform = _platformController.text;
      widget.game!.genre = _genreController.text;
      widget.game!.status = _selectedStatus!;
      ref.read(gameListProvider.notifier).updateGame(widget.game!);
    } else {
      // We are in Add Mode
      final newGame = Game(
        title: _titleController.text,
        platform: _platformController.text,
        genre: _genreController.text,
        status: _selectedStatus!,
        dateAdded: DateTime.now(),
      );
      ref.read(gameListProvider.notifier).addGame(newGame);
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
          IconButton(icon: const Icon(Icons.save), onPressed: _saveForm),
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
                validator: (value) => value!.trim().isEmpty ? 'Please enter a title.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _platformController,
                decoration: const InputDecoration(labelText: 'Platform'),
                validator: (value) => value!.trim().isEmpty ? 'Please enter a platform.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _genreController,
                decoration: const InputDecoration(labelText: 'Genre'),
                validator: (value) => value!.trim().isEmpty ? 'Please enter a genre.' : null,
              ),
              const SizedBox(height: 16),
              // --- UPDATED DROPDOWN ---
              DropdownButtonFormField<GameStatus>(
                initialValue: _selectedStatus,
                decoration: const InputDecoration(labelText: 'Status'),
                // Use GameStatus.values to get all possible enum options
                items: GameStatus.values.map((GameStatus status) {
                  return DropdownMenuItem<GameStatus>(
                    value: status,
                    child: Text(_getStatusText(status)),
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