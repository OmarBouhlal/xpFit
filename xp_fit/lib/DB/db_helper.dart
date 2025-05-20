import 'dart:ffi';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'users.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id_user INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL,
            email TEXT NOT NULL,
            password TEXT NOT NULL,
            weight REAL NOT NULL,
            height REAL NOT NULL,
            birthDate INTEGER NOT NULL,
            gender TEXT NOT NULL,

          ),
          CREATE TABLE exercices (
            id_exercice INTEGER PRIMARY KEY AUTOINCREMENT,

          ),
          CREATE TABLE user_exe (   
            id_user INTEGER PRIMARY KEY AUTOINCREMENT,
            id_exercice INTEGER NOT NULL,
          ),
          CREATE TABLE user_nut (   
            id_user INTEGER PRIMARY KEY AUTOINCREMENT,
            id_nutrition INTEGER NOT NULL,
          ),
          CREATE TABLE nutrition (
            id_nutrition INTEGER PRIMARY KEY AUTOINCREMENT,

          ),
          CREATE TABLE objectives (
            id_obj INTEGER PRIMARY KEY AUTOINCREMENT,
            id_user INTEGER NOT NULL,
            obj_weight REAL NOT NULL,
          ),
        ''');
      },
    );
  }

  static Future<void> Registration(String username, String email , String password , String birthDate , Float weight , Float height , String gender) async {
    final db = await database;
    await db.insert(
      'users',
      {'username': username, 'email': email, 'password': password, 'birthDate' : birthDate ,'weight': weight, 'height': height , 'gender' : gender  },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<bool> checkLogin(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty;
  }
}