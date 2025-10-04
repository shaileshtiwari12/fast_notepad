// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:fast_notepad/model/notes_model.dart';
import 'package:fast_notepad/services/detabase_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class AddEditNoteScreens extends StatefulWidget {
  const AddEditNoteScreens({super.key, this.note});
  final NotesModel? note;
  @override
  State<AddEditNoteScreens> createState() => _AddEditNoteScreensState();
}

class _AddEditNoteScreensState extends State<AddEditNoteScreens> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final DatabaseHelpar _databaseHelpar = DatabaseHelpar();
  Color _selectedColor = const Color(0xffF73669);

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
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5), // Light gray background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
          onPressed: ()  {
             _saveNote();
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.note == null ? 'Add Note' : 'Edit Note',
          
          style: const TextStyle(
            color: Color(0xff1A1A1A),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showColorPicker(context);
            },
            icon: const Icon(Icons.color_lens, color: Color(0xff5D5D5D)),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () async {
                await _saveNote();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.done, color: Color(0xffF73669)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              TextFormField(
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Color(0xff1A1A1A),
                ),
                minLines: 1,
                maxLines: 2,
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                maxLines: 500,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xff333333),
                  height: 1.5,
                ),
                keyboardType: TextInputType.multiline,
                controller: _contentController,
                decoration: InputDecoration(
                  hintText: 'Type your note here...',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    Color tempColor = _selectedColor;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: _selectedColor,
              onColorChanged: (color) {
                tempColor = color;
              },
            ),
          ),
          actions: [
            TextButton(
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.black54)),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child:
                  const Text('Select', style: TextStyle(color: Colors.white)),
              onPressed: () {
                setState(() => _selectedColor = tempColor);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
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
