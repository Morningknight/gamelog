import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamelog/models/game.dart';
import 'package:gamelog/models/tag_data.dart';
import 'package:gamelog/providers/game_provider.dart';
import 'package:gamelog/widgets/tag_selector.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddEditGameScreen extends ConsumerStatefulWidget {
  final Game? game;
  final GameStatus? defaultStatus; // Accepts a default status

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
      // Use the default status passed from the FAB menu, or fallback to backlog
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
                value: _selectedStatus,
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
      ),
    );
  }
}