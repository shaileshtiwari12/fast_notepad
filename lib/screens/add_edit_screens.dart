import 'package:fast_notepad/model/notes_model.dart';
import 'package:fast_notepad/screens/home_screen.dart';
import 'package:fast_notepad/services/detabase_handler.dart';
import 'package:flutter/material.dart';

class AddEditNoteScreens extends StatefulWidget {
  const AddEditNoteScreens({super.key, this.note});
  final NotesModel? note;
  @override
  State<AddEditNoteScreens> createState() => _AddEditNoteScreensState();
}

class _AddEditNoteScreensState extends State<AddEditNoteScreens> {
  // final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final DatabaseHelpar _databaseHelpar = DatabaseHelpar();
  Color _selectedColor = Colors.amber;
  final List<Color> _colors = [
    Colors.amber,
    Colors.red,
    Colors.pink,
    Colors.green,
    const Color.fromARGB(255, 89, 54, 244),
    const Color.fromARGB(255, 30, 192, 233),
    const Color.fromARGB(255, 4, 251, 12),
    const Color.fromARGB(255, 228, 244, 54),
    const Color.fromARGB(255, 213, 30, 233),
    const Color.fromARGB(255, 245, 155, 30),
    const Color.fromARGB(255, 22, 67, 0),
    const Color.fromARGB(255, 78, 5, 61),
    const Color.fromARGB(255, 9, 31, 10),
    const Color.fromARGB(255, 5, 52, 112),
    const Color.fromARGB(255, 32, 24, 32),
    const Color.fromARGB(255, 150, 86, 3),
  ];
  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _selectedColor = Color(int.parse(widget.note!.color));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          widget.note == null ? 'Add Note' : 'Edit Note',
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: GridView(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5),
                      children: _colors.map(
                        (color) {
                          return GestureDetector(
                            onTap: () {
                              setState(() => _selectedColor = color);
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: _selectedColor == color
                                        ? Colors.black45
                                        : Colors.transparent,
                                    width: 2),
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.color_lens),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () async {
                _saveNote();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.done),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                minLines: 1,
                maxLines: 2,
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Title...',
                  border: InputBorder.none,
                ),
              ),
              TextFormField(
                maxLines: 500,
                style: const TextStyle(fontSize: 16,letterSpacing: 0.1,),
                keyboardType: TextInputType.multiline,
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: 'Content...',
                  border: InputBorder.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveNote() async {
    final note = NotesModel(
      id: widget.note?.id,
      title: _titleController.text,
      content: _contentController.text,
      color: _selectedColor.value.toString(),
      dateTime: DateTime.now().toString(),
    );
    if (widget.note == null) {
      await _databaseHelpar.insertNote(note);
    } else {
      await _databaseHelpar.updateNote(note);
    }
  }
}
