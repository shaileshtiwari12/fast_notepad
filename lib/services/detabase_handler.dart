import 'package:hive_flutter/hive_flutter.dart';
import 'package:fast_notepad/model/notes_model.dart';

class DatabaseHelpar {
  static const String _boxName = "notesBox";
  static bool _initialized = false;

  /// Hive initialize (Web + Mobile दोनों के लिए)
  static Future<void> init() async {
    if (!_initialized) {
      await Hive.initFlutter(); // web → IndexedDB, mobile → local dir
      Hive.registerAdapter(NotesModelAdapter());
      await Hive.openBox<NotesModel>(_boxName);
      _initialized = true;
    }
  }

  /// Insert new note
  Future<void> insertNote(NotesModel note) async {
    final box = Hive.box<NotesModel>(_boxName);
    note.id ??= DateTime.now().millisecondsSinceEpoch;
    await box.put(note.id, note);
  }

  /// Get all notes
  Future<List<NotesModel>> getNotes() async {
    final box = Hive.box<NotesModel>(_boxName);
    return box.values.toList();
  }

  /// Update note
  Future<void> updateNote(NotesModel note) async {
    final box = Hive.box<NotesModel>(_boxName);
    if (note.id != null) {
      await box.put(note.id, note);
    }
  }

  /// Delete note
  Future<void> deleteNote(int id) async {
    final box = Hive.box<NotesModel>(_boxName);
    await box.delete(id);
  }
}
