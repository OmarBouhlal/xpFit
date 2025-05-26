import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final int _databaseVersion = 9; // Increment version to trigger schema update
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
            id_user INTEGER,
            id_nutrition INTEGER NOT NULL
          );
        ''');

        await db.execute('''
          CREATE TABLE meals (
            id INTEGER PRIMARY KEY,
            title TEXT,
            image TEXT,
            imageType TEXT,
            readyInMinutes INTEGER,
            servings INTEGER,
            sourceUrl TEXT,
            day TEXT
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
        // Handle database upgrades
        if (oldVersion < 6) {
          // Drop and recreate problematic table
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

class WebStorageHelper {
  // In-memory storage for web (this is just for demo/development)
  static List<Map<String, dynamic>> _users = [];
  
  static Future<void> registration(
    String username,
    String email,
    String password,
    double weight,
    double height,
    String birthDate,
    String gender,
  ) async {
    // Check if user already exists
    final existingUser = _users.firstWhere(
      (user) => user['email'] == email,
      orElse: () => {},
    );
    
    if (existingUser.isNotEmpty) {
      throw Exception('User with this email already exists');
    }
    
    // Add new user
    _users.add({
      'id_user': _users.length + 1,
      'username': username,
      'email': email,
      'password': password,
      'weight': weight,
      'height': height,
      'birthDate': birthDate,
      'gender': gender,
      'avatar': null,
    });
    
    print('User registered successfully (web storage)');
  }
  
  static Future<bool> checkLogin(String email, String password) async {
    final user = _users.firstWhere(
      (user) => user['email'] == email && user['password'] == password,
      orElse: () => {},
    );
    return user.isNotEmpty;
  }
  
  static Future<Map<String, dynamic>?> retrieve_user(String email) async {
    try {
      final user = _users.firstWhere(
        (user) => user['email'] == email,
        orElse: () => {},
      );
      return user.isNotEmpty ? user : null;
    } catch (e) {
      return null;
    }
  }
  
  static Future<void> add_avatar(String email, String avatar) async {
    final userIndex = _users.indexWhere((user) => user['email'] == email);
    if (userIndex != -1) {
      _users[userIndex]['avatar'] = avatar;
    }
  }
}

  static Future<Map<String,dynamic>?> retrieve_user(String email) async {
    final db = await database;
    final result = await db.query('users', where: 'email = ?', whereArgs: [email]);
    return result.isNotEmpty ? result.first : null;
  } 

    static Future<List<Map<String, dynamic>>> getFavorites(
    String selectedFilter,
    String? email,
  ) async {
    final db = await database;
    try {
      final user = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
        limit: 1,
      );
      final userId = user.first['id_user'] as int;
      final results = await db.query(
        selectedFilter,
        where: 'id_user = ?',
        whereArgs: [userId],
      );
      return results;
    } catch (e) {
      print('Error fetching favorites: $e');
      rethrow; // Re-throw the error to handle it in the calling code
    }
  }

  static Future<void> addExercice(
  String email,
  String id_exercice,
  String name_exercice,
  String? gifUrl,
  List<dynamic> instructions,
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
    print("Adding exercise for user ID: $userId");
    
    // Check if exercise already exists for this user
    final existing = await db.query(
      'exe_user',
      where: 'id_exercice = ? AND id_user = ?',
      whereArgs: [id_exercice, userId],
    );
    
    if (existing.isNotEmpty) {
      print('Exercise already exists in favorites');
      return;
    }
    
    // Convert instructions list to string if needed
    String instructionsStr = instructions.join('; ');
    
    await db.insert('exe_user', {
      'id_exercice': id_exercice,
      'id_user': userId,
      'name_exercice': name_exercice,
      'gifUrl': gifUrl,
      'instructions': instructionsStr,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    
    print("Exercise added successfully");
  } catch (e) {
    print('Error adding exercise: $e');
    rethrow;
  }
}

  // Add this method to your DBHelper class
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
  

}
