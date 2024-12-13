import 'package:sqflite/sqflite.dart';
import 'package:fast_notepad/model/notes_model.dart';
import 'package:path/path.dart' show join;
import 'dart:io' as io;

class DatabaseHelpar {
  static final DatabaseHelpar _instance = DatabaseHelpar._internal();
  static Database? _database;
  factory DatabaseHelpar() => _instance;
  DatabaseHelpar._internal();

  Future<Database?> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_notes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE notes(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          content TEXT,
          color TEXT,
          datetime TEXT
         )
       ''');
  }

  Future<int> insertNote(Note note) async {
    final db = await database;
    return await db!.insert('notes', note.toMap());
  }

  Future<List<Note>> getNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('notes');
    return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
  }

  Future<int> updateNote(Note note) async {
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
