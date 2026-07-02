import 'package:flutter/material.dart';
import 'add_note.dart';
import 'note.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Note> _notes = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _addNote() async {
    final newNote = await Navigator.push<Note>(
      context,
      MaterialPageRoute(builder: (context) => const AddNote()),
    );

    if (newNote != null) {
      setState(() {
        _notes.insert(0, newNote);
      });
    }
  }

  Future<void> _editNote(int index) async {
    final updatedNote = await Navigator.push<Note>(
      context,
      MaterialPageRoute(
        builder: (context) => AddNote(existingNote: _notes[index]),
      ),
    );

    if (updatedNote != null) {
      setState(() {
        _notes[index] = updatedNote;
      });
    }
  }

  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = '';
      }
    });
  }

  List<Note> get _filteredNotes {
    if (_searchQuery.isEmpty) return _notes;
    return _notes
        .where((note) =>
            note.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            note.content.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final notesToShow = _filteredNotes;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 241, 214),
      appBar: AppBar(
        titleSpacing: 40,
        backgroundColor: const Color.fromARGB(255, 232, 185, 98),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search notes...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              )
            : const Text(
                'My Notes',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
        ],
      ),
      body: notesToShow.isEmpty
          ? Center(
              child: Text(
                _searchQuery.isEmpty ? 'No notes yet' : 'No notes found',
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: notesToShow.length,
              itemBuilder: (context, index) {
                final note = notesToShow[index];
                return Dismissible(
                  key: ValueKey(note.createdAt),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => _deleteNote(_notes.indexOf(note)),
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      onTap: () => _editNote(_notes.indexOf(note)),
                      title: Text(
                        note.title,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        note.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        backgroundColor: const Color.fromARGB(255, 232, 185, 98),
        child: const Icon(Icons.add),
      ),
    );
  }
}