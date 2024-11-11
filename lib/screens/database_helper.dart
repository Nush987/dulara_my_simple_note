//import 'dart:async';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:my_simple_note/models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DatabaseHelper {
  static Database? _database;

  // Singleton pattern to ensure only one instance of the database
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initializeDB();
    return _database!;
  }

  Future<Database> initializeDB() async {
    // Use the ffi web factory on the web platform
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    }

    String path; // initiate database path var
    if (kIsWeb) {
      // Web-specific database path (for web platforms, this is the db path)
      path = 'notes_db.db';
    } else {
      // Mobile/desktop path (for mobile/desktop platforms, this is the db path)
      path = await getDatabasesPath();
      path = join(path, 'notes_db.db');
    }

    // Open the database and create table if it does not exist
    Database db = await openDatabase(
      path,
      version: 1,
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE notes (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, content TEXT NOT NULL, date TEXT NOT NULL)",
        );
      },
    );
    return db;
  }

  Future<int> insert(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('notes', row);
  }

  Future<List<Note>> queryAllRows() async {
    final db = await database;
    final List<Map<String, Object?>> queryResult = await db.query('notes'); // Query all notes
    return queryResult.map((e) => Note.fromMap(e)).toList(); //
  }

  Future<int> update(Map<String, dynamic> row) async {
    final db = await database;
    int id = row['id'];
    return await db.update('notes', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
