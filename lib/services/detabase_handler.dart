import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fast_notepad/model/notes_model.dart';
import 'package:path/path.dart' show join;

class DatabaseHelpar {
  static Database? _database;

  

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'my_notes.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE notes(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          content TEXT,
          color TEXT,
          datetime TEXT
         )
       ''');
      },
    );
    return _database;
  }

   insertNote(NotesModel note) async {
    final db = await database;
    return await db!.insert('notes', note.toMap());
  }

  Future<List<NotesModel>> getNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('notes');
    return List.generate(maps.length, (i) => NotesModel.fromMap(maps[i]));
  }

  Future<int> updateNote(NotesModel note) async {
    final db = await database;
    return await db!.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db!.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
