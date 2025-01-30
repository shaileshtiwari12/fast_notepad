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
    const Color(0xffFFB6C1),
    const Color(0xffADD8E6),
    const Color(0xffFFFF99),
    const Color(0xffE6E6FA),
    const Color(0xff98FB98),
    const Color(0xffFFDAB9),
    const Color(0xffFFFDD0),
    const Color(0xff87CEEB),
    const Color(0xffB0E0E6),
    const Color(0xffFFFFF0),
    const Color(0xffC8A2C8),
    const Color(0xffFFC0CB),
    const Color(0xffF7E7CE),
    const Color(0xffCCCCFF),
    const Color(0xff77DD77),
    const Color(0xffF08080),
    const Color(0xffF5F5DC),
    const Color(0xffFFE4E1),
    const Color(0xffF0FFF0),
    const Color(0xffFFFACD),
    const Color(0xffAFEEEE),
    const Color(0xffFFF5EE),
    const Color(0xffF0F8FF),
    const Color(0xffF0FFFF),
    const Color(0xffDCD0FF),
    const Color(0xffE0FFFF),
    const Color(0xffFFDAB9),
    const Color(0xffF5FFFA),
    const Color(0xffFFFAFA),
    const Color(0xffF5DEB3),
    const Color(0xffE7ACCF),
    const Color(0xffF7CAC9),
    const Color(0xffF4A460),
    const Color(0xffFADADD),
    const Color(0xffE0B0FF),
    const Color(0xffFAFAFA),
    const Color(0xffFFFAF0),
    const Color(0xffF8F0E3),
    const Color(0xffF4C2C2),
    const Color(0xffFFB7C5),
    const Color(0xffF3E5AB),
    const Color(0xffFFFFE0),
    const Color(0xffD8BFD8),
    const Color(0xffECE5B6),
    const Color(0xffF0E68C),
    const Color(0xffF5F5F5),
    const Color(0xffFFDFDD),
    const Color(0xffFFC1CC),
    const Color(0xffF0EAD6),
    const Color(0xffD3E2F4),
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.cyan,
    Colors.lime,
    Colors.indigo,
    Colors.brown,
    Colors.grey,
    Colors.amber,
    Colors.deepOrange,
    Colors.deepPurple,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.blueGrey,
    Colors.redAccent,
    Colors.greenAccent,
    Colors.blueAccent,
    Colors.yellowAccent,
    Colors.orangeAccent,
    Colors.purpleAccent,
    Colors.pinkAccent,
    Colors.tealAccent,
    Colors.cyanAccent,
    Colors.limeAccent,
    Colors.indigoAccent,
    Colors.amberAccent,
    Colors.white,
    Colors.black,
    const Color(0xFFFFA07A), // Light Salmon
    const Color(0xFF20B2AA), // Light Sea Green
    const Color(0xFF778899), // Light Slate Gray
    const Color(0xFFB0C4DE), // Light Steel Blue
    const Color(0xFF32CD32), // Lime Green
    const Color(0xFF800000), // Maroon
    const Color(0xFF66CDAA), // Medium Aquamarine
    const Color(0xFF0000CD), // Medium Blue
    const Color(0xFFBA55D3), // Medium Orchid
    const Color(0xFF9370DB), // Medium Purple
    const Color(0xFF3CB371), // Medium Sea Green
    const Color(0xFF7B68EE), // Medium Slate Blue
    const Color(0xFF00FA9A), // Medium Spring Green
    const Color(0xFF48D1CC), // Medium Turquoise
    const Color(0xFFC71585), // Medium Violet Red
    const Color(0xFF191970), // Midnight Blue
    const Color(0xFFF5FFFA), // Mint Cream
    const Color(0xFFFFE4B5), // Moccasin
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
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                style: const TextStyle(
                  fontSize: 16,
                  letterSpacing: 0.1,
                ),
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
