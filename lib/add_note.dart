import 'package:flutter/material.dart';
import 'note.dart';

class AddNote extends StatefulWidget {
  final Note? existingNote;

  const AddNote({super.key, this.existingNote});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill with existing note data if editing
    if (widget.existingNote != null) {
      _titleController.text = widget.existingNote!.title;
      _contentController.text = widget.existingNote!.content;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      // Nothing to save, just go back
      Navigator.pop(context);
      return;
    }

    final note = Note(
      title: title.isEmpty ? 'Untitled' : title,
      content: content,
      createdAt: widget.existingNote?.createdAt,
    );

    // Return the new note to HomePage
    Navigator.pop(context, note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 241, 214),
      appBar: AppBar(
        title: Text(widget.existingNote != null ? 'Edit Note' : 'Add Note'),
        backgroundColor: const Color.fromARGB(255, 232, 185, 98),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Note Title',
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  alignLabelWithHint: true,
                  hintText: 'Start typing your note...',
                ),
                maxLines: null,
                expands: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}