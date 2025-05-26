import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;
  static Map<String, List<Map<String, dynamic>>> _webStorage = {};

  static Future<Database?> get database async {
    if (kIsWeb) {
      // For web, we'll use in-memory storage
      _initWebStorage();
      return null; // Return null for web, we'll handle storage differently
    }
    
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static void _initWebStorage() {
    if (_webStorage.isEmpty) {
      _webStorage = {
        'users': [],
        'exe_user': [],
        'exe_tmuscle': [],
        'muscles': [],
        'user_nut': [],
        'user_objective': [],
        'objective': [],
      };
    }
  }

  static Future<Database> _initDB() async {
    final int _databaseVersion = 10; // Increment version to trigger schema update
    String path = join(await getDatabasesPath(), 'users.db');
    
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id_user INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL,
            email TEXT NOT NULL,
            password TEXT NOT NULL,
            weight REAL NOT NULL,
            height REAL NOT NULL,
            birthDate TEXT,
            gender TEXT,
            obj_weight REAL,
            avatar TEXT
          );
        ''');

        await db.execute('''
          CREATE TABLE exe_user (
            id_user_exercice INTEGER PRIMARY KEY AUTOINCREMENT,
            id_exercice TEXT,
            id_user INTEGER NOT NULL,
            name_exercice TEXT NOT NULL,
            gifUrl TEXT,
            instructions TEXT
          );
        ''');

        await db.execute('''
          CREATE TABLE exe_tmuscle (
            id_exe_tmuscle INTEGER PRIMARY KEY AUTOINCREMENT,
            id_exercice INTEGER,
            id_muscle INTEGER
          );
        ''');

        await db.execute('''
          CREATE TABLE muscles (
            id_muscle INTEGER PRIMARY KEY AUTOINCREMENT,
            name_muscle TEXT NOT NULL
          );
        ''');

        await db.execute('''
          CREATE TABLE user_nut (
            id_user_nut INTEGER PRIMARY KEY AUTOINCREMENT,
            id_user INTEGER NOT NULL,
            id_nutrition INTEGER NOT NULL,
            title TEXT,
            sourceUrl TEXT,
            readyInMinutes INTEGER,
            image TEXT
          );
        ''');


        await db.execute('''
          CREATE TABLE user_objective (
            id_user_obj INTEGER PRIMARY KEY AUTOINCREMENT,
            id_obj INTEGER NOT NULL,
            id_user INTEGER NOT NULL
          );
        ''');

        await db.execute('''
          CREATE TABLE objective (
            id_obj INTEGER PRIMARY KEY AUTOINCREMENT,
            name_obj TEXT NOT NULL
          );
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 6) {
          await db.execute('DROP TABLE IF EXISTS user_objective');
          await db.execute('''
            CREATE TABLE user_objective (
              id_user_obj INTEGER PRIMARY KEY AUTOINCREMENT,
              id_obj INTEGER NOT NULL,
              id_user INTEGER NOT NULL
            );
          ''');
        }
      },
    );
  }

  // Web-compatible insert method
  static Future<void> _webInsert(String table, Map<String, dynamic> data) async {
    _initWebStorage();
    
    // Generate ID for primary key
    int maxId = 0;
    if (_webStorage[table]!.isNotEmpty) {
      String primaryKey = _getPrimaryKey(table);
      maxId = _webStorage[table]!
          .map((e) => e[primaryKey] as int? ?? 0)
          .reduce((a, b) => a > b ? a : b);
    }
    
    data[_getPrimaryKey(table)] = maxId + 1;
    _webStorage[table]!.add(data);
  }

  // Web-compatible query method
  static Future<List<Map<String, dynamic>>> _webQuery(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
    int? limit,
  }) async {
    _initWebStorage();
    
    List<Map<String, dynamic>> results = List.from(_webStorage[table]!);
    
    if (where != null && whereArgs != null) {
      // Simple where clause parsing (supports basic conditions)
      List<String> conditions = where.split(' AND ');
      
      for (String condition in conditions) {
        if (condition.contains(' = ?')) {
          String column = condition.split(' = ?')[0].trim();
          int argIndex = conditions.indexOf(condition);
          if (argIndex < whereArgs.length) {
            dynamic value = whereArgs[argIndex];
            results = results.where((row) => row[column] == value).toList();
          }
        }
      }
    }
    
    if (limit != null && limit > 0) {
      results = results.take(limit).toList();
    }
    
    return results;
  }

  // Web-compatible update method
  static Future<void> _webUpdate(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    _initWebStorage();
    
    if (where != null && whereArgs != null) {
      String column = where.split(' = ?')[0].trim();
      dynamic value = whereArgs[0];
      
      for (int i = 0; i < _webStorage[table]!.length; i++) {
        if (_webStorage[table]![i][column] == value) {
          _webStorage[table]![i].addAll(values);
          break;
        }
      }
    }
  }

  static String _getPrimaryKey(String table) {
    switch (table) {
      case 'users': return 'id_user';
      case 'exe_user': return 'id_user_exercice';
      case 'user_nut': return 'id_user_nut';
      case 'user_objective': return 'id_user_obj';
      case 'objective': return 'id_obj';
      case 'muscles': return 'id_muscle';
      case 'exe_tmuscle': return 'id_exe_tmuscle';
      default: return 'id';
    }
  }

  static Future<void> registration(
    String username,
    String email,
    String password,
    double weight,
    double height,
    String birthDate,
    String gender,
  ) async {
    Map<String, dynamic> userData = {
      'username': username,
      'email': email,
      'password': password,
      'weight': weight,
      'height': height,
      'birthDate': birthDate,
      'gender': gender,
    };

    if (kIsWeb) {
      await _webInsert('users', userData);
    } else {
      final db = await database;
      await db!.insert('users', userData, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  static Future<bool> checkLogin(String email, String password) async {
    List<Map<String, dynamic>> result;
    
    if (kIsWeb) {
      result = await _webQuery('users', where: 'email = ? AND password = ?', whereArgs: [email, password]);
    } else {
      final db = await database;
      result = await db!.query(
        'users',
        where: 'email = ? AND password = ?',
        whereArgs: [email, password],
      );
    }
    
    return result.isNotEmpty;
  }  
  
  static Future<void> add_avatar(String email, String avatar) async {
    if (kIsWeb) {
      await _webUpdate('users', {'avatar': avatar}, where: 'email = ?', whereArgs: [email]);
    } else {
      final db = await database;
      await db!.update(
        'users',
        {'avatar': avatar},
        where: 'email = ?',
        whereArgs: [email]
      );
    }
  }

  static Future<void> resetDatabase() async {
    if (kIsWeb) {
      _webStorage.clear();
      _initWebStorage();
    } else {
      String path = join(await getDatabasesPath(), 'users.db');
      await deleteDatabase(path);
      _db = null;
    }
  }

  static Future<Map<String,dynamic>?> retrieve_user(String email) async {
    List<Map<String, dynamic>> result;
    
    if (kIsWeb) {
      result = await _webQuery('users', where: 'email = ?', whereArgs: [email]);
    } else {
      final db = await database;
      result = await db!.query('users', where: 'email = ?', whereArgs: [email]);
    }
    
    return result.isNotEmpty ? result.first : null;
  } 

  static Future<List<Map<String, dynamic>>> getFavorites(
    String selectedFilter,
    String? email,
  ) async {
    try {
      List<Map<String, dynamic>> user;
      
      if (kIsWeb) {
        user = await _webQuery('users', where: 'email = ?', whereArgs: [email], limit: 1);
      } else {
        final db = await database;
        user = await db!.query('users', where: 'email = ?', whereArgs: [email], limit: 1);
      }
      
      if (user.isEmpty) return [];
      
      final userId = user.first['id_user'] as int;
      
      if (kIsWeb) {
        return await _webQuery(selectedFilter, where: 'id_user = ?', whereArgs: [userId]);
      } else {
        final db = await database;
        return await db!.query(selectedFilter, where: 'id_user = ?', whereArgs: [userId]);
      }
    } catch (e) {
      print('Error fetching favorites: $e');
      return [];
    }
  }

  static Future<void> addExercice(
    String email,
    String id_exercice,
    String name_exercice,
    String? gifUrl,
    List<dynamic> instructions,
  ) async {
    try {
      List<Map<String, dynamic>> user;
      
      if (kIsWeb) {
        user = await _webQuery('users', where: 'email = ?', whereArgs: [email], limit: 1);
      } else {
        final db = await database;
        user = await db!.query('users', where: 'email = ?', whereArgs: [email], limit: 1);
      }
      
      if (user.isEmpty) {
        print('Error: User not found with email: $email');
        throw Exception('User not found');
      }
      
      final userId = user.first['id_user'] as int;
      print("Adding exercise for user ID: $userId");
      
      // Check if exercise already exists
      List<Map<String, dynamic>> existing;
      if (kIsWeb) {
        existing = await _webQuery('exe_user', where: 'id_exercice = ? AND id_user = ?', whereArgs: [id_exercice, userId]);
      } else {
        final db = await database;
        existing = await db!.query('exe_user', where: 'id_exercice = ? AND id_user = ?', whereArgs: [id_exercice, userId]);
      }
      
      if (existing.isNotEmpty) {
        print('Exercise already exists in favorites');
        return;
      }
      
      String instructionsStr = instructions.join('; ');
      
      Map<String, dynamic> exerciseData = {
        'id_exercice': id_exercice,
        'id_user': userId,
        'name_exercice': name_exercice,
        'gifUrl': gifUrl,
        'instructions': instructionsStr,
      };

      if (kIsWeb) {
        await _webInsert('exe_user', exerciseData);
      } else {
        final db = await database;
        await db!.insert('exe_user', exerciseData, conflictAlgorithm: ConflictAlgorithm.replace);
      }
      
      print("Exercise added successfully");
    } catch (e) {
      print('Error adding exercise: $e');
      rethrow;
    }
  }

  static Future<void> debugTables() async {
    final db = await database;
    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table';"
    );
    print('Available tables:');
    for (var table in tables) {
      print('- ${table['name']}');
    }
  }
  

  //nutrition stuff

  static Future<void> addNutrition(
  String email,
  int id_nutrition,
  String title,
  String? sourceUrl,
  String image
  ) async {
    final db = await database;
    try {
      final user = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
        limit: 1,
      );
      
      if (user.isEmpty) {
        print('Error: User not found with email: $email');
        throw Exception('User not found');
      }
      
      final userId = user.first['id_user'] as int;
      print("Adding nutrition for user ID: $userId");
      
      // Check if exercise already exists for this user
      final existing = await db.query(
        'user_nut',
        where: 'id_nutrition = ? AND id_user = ?',
        whereArgs: [id_nutrition, userId],
      );
      
      if (existing.isNotEmpty) {
        print('Nutrition already exists in favorites');
        return;
      }
      
      await db.insert('user_nut', {
        'id_nutrition': id_nutrition,
        'id_user': userId,
        'title': title,
        'sourceUrl': sourceUrl,
        'image': image,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      
      print("Nutrition added successfully");
    } catch (e) {
      print('Error adding nutrition: $e');
      rethrow;
    }
}

}
