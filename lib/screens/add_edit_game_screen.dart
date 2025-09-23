import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamelog/models/game.dart';
import 'package:gamelog/models/tag_data.dart';
import 'package:gamelog/providers/game_provider.dart';
import 'package:gamelog/widgets/tag_selector.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddEditGameScreen extends ConsumerStatefulWidget {
  final Game? game;
  final GameStatus? defaultStatus;

  const AddEditGameScreen({super.key, this.game, this.defaultStatus});

  @override
  ConsumerState<AddEditGameScreen> createState() => _AddEditGameScreenState();
}

class _AddEditGameScreenState extends ConsumerState<AddEditGameScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  String? _selectedPlatform;
  String? _selectedGenre;
  GameStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    if (widget.game != null) { // Edit Mode
      _titleController.text = widget.game!.title;
      _selectedPlatform = widget.game!.platform;
      _selectedGenre = widget.game!.genre;
      _selectedStatus = widget.game!.status;
    } else { // Add Mode
      _selectedStatus = widget.defaultStatus ?? GameStatus.backlog;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _showPlatformSelector() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => TagSelector(
        title: 'Select a Platform',
        tags: platformTags,
        currentlySelected: _selectedPlatform,
      ),
    );
    if (result != null) setState(() => _selectedPlatform = result);
  }

  void _showGenreSelector() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => TagSelector(
        title: 'Select a Genre',
        tags: genreTags,
        currentlySelected: _selectedGenre,
      ),
    );
    if (result != null) setState(() => _selectedGenre = result);
  }

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

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedPlatform == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a platform.')));
        return;
      }
      if (_selectedGenre == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a genre.')));
        return;
      }

      final gameData = Game(
        title: _titleController.text,
        platform: _selectedPlatform!,
        genre: _selectedGenre!,
        status: _selectedStatus!,
        dateAdded: widget.game?.dateAdded ?? DateTime.now(),
      );

      if (widget.game != null) {
        Hive.box<Game>('games').put(widget.game!.key, gameData);
        ref.read(gameListProvider.notifier).refreshGames();
      } else {
        ref.read(gameListProvider.notifier).addGame(gameData);
      }
      Navigator.of(context).pop();
    }
  }

  void _deleteGame() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to permanently delete this game? This action cannot be undone.'),
        actions: [
          TextButton(
            child: const Text('No'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Yes, Delete'),
            onPressed: () {
              ref.read(gameListProvider.notifier).deleteGame(widget.game!);
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.game != null;
    final appBarTitle = isEditing ? 'Edit Game' : 'Add New Game';

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        // --- THE SAVE ICONBUTTON HAS BEEN REMOVED FROM THE ACTIONS LIST ---
        actions: const [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                      validator: (value) => value!.trim().isEmpty ? 'Please enter a title.' : null,
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Platform'),
                      subtitle: Text(_selectedPlatform ?? 'Not selected'),
                      trailing: const Icon(Icons.arrow_drop_down),
                      onTap: _showPlatformSelector,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Genre'),
                      subtitle: Text(_selectedGenre ?? 'Not selected'),
                      trailing: const Icon(Icons.arrow_drop_down),
                      onTap: _showGenreSelector,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<GameStatus>(
                      initialValue: _selectedStatus,
                      decoration: const InputDecoration(labelText: 'Status'),
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
              const SizedBox(height: 20),
              if (isEditing)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.delete_forever),
                        label: const Text('Delete'),
                        onPressed: _deleteGame,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FilledButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text('Save Changes'),
                        onPressed: _saveForm,
                      ),
                    ),
                  ],
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add Game'),
                    onPressed: _saveForm,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}