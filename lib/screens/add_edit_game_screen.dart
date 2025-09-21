import 'package:flutter/material.dart';

class AddEditGameScreen extends StatefulWidget {
  const AddEditGameScreen({super.key});

  @override
  State<AddEditGameScreen> createState() => _AddEditGameScreenState();
}

class _AddEditGameScreenState extends State<AddEditGameScreen> {
  // A GlobalKey is needed to identify and validate our Form.
  final _formKey = GlobalKey<FormState>();

  // Controllers to manage the text inside the TextFormFields.
  final _titleController = TextEditingController();
  final _platformController = TextEditingController();
  final _genreController = TextEditingController();

  // A variable to hold the selected value from the dropdown.
  String? _selectedStatus = 'Not Started'; // Default value

  // List of options for our status dropdown menu.
  final List<String> _statuses = ['Not Started', 'Now Playing', 'Paused', 'Beaten', 'Dropped'];

  // This method is called when the widget is removed from the widget tree.
  // It's important to dispose of controllers to free up resources.
  @override
  void dispose() {
    _titleController.dispose();
    _platformController.dispose();
    _genreController.dispose();
    super.dispose();
  }

  void _saveForm() {
    // This runs the validator function on each TextFormField.
    // If all are valid, it returns true.
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return; // If not valid, stop the function here.
    }

    // If the form is valid, we'll save the data to Hive in a later step.
    // For now, let's just print the data to the console to confirm it works.
    print('Game Title: ${_titleController.text}');
    print('Platform: ${_platformController.text}');
    print('Genre: ${_genreController.text}');
    print('Status: $_selectedStatus');

    // Go back to the previous screen (HomeScreen).
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Game'),
        actions: [
          // A save button in the AppBar.
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Associate the key with our Form.
          child: ListView( // Use ListView to prevent overflow on smaller screens.
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next, // Moves to the next field
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title.'; // Validation error message
                  }
                  return null; // Means the input is valid
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
                textInputAction: TextInputAction.done, // Shows a "done" button on keyboard
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