import 'package:fast_notepad/ads/bannerAds.dart';
import 'package:fast_notepad/screens/add_edit_screens.dart';
import 'package:fast_notepad/screens/view_note_screens.dart';
import 'package:fast_notepad/services/detabase_handler.dart';
import 'package:fast_notepad/model/notes_model.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelpar _databaseHelpar = DatabaseHelpar();
  List<NotesModel> _notes = [];
  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notes = await _databaseHelpar.getNotes();
    setState(() {
      _notes = notes;
    });
  }

  String _formatDateTime(String dateTime) {
    final DateTime dt = DateTime.parse(dateTime);
    final now = DateTime.now();
    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return 'Today, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(0, '0')}';
    }
    return ' ${dt.day}/${dt.month}/${dt.year}, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(0, '0')}';
  }

  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isDialOpen.value) {
          isDialOpen.value = false;
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Notepad'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16),
                  itemCount: _notes.length,
                  itemBuilder: (context, index) {
                    final note = _notes[index];
                    final color = Color(int.parse(note.color));
                    return GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewNoteScreens(note: note),
                            ));
                        _loadNotes();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              )
                            ]),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              note.title,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              note.content,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.white70),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Spacer(),
                            Text(
                              _formatDateTime(note.dateTime),
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              color: Colors.white,
              width: double.infinity,
              height: 50,
              child: const BannerAds(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xffF73669),
          onPressed: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddEditNoteScreens(),
                ));
            _loadNotes();
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
