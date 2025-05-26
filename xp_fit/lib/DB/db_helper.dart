import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

<<<<<<< Updated upstream
// For web, use a simple in-memory storage
// For mobile, use SQLite (you'll need to keep your original SQLite code for mobile)
=======

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final int _databaseVersion = 6; // Increment version to trigger schema update
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
          CREATE TABLE exercices (
            id_exercice INTEGER PRIMARY KEY,
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
          CREATE TABLE user_exe (
            id_user_exe INTEGER PRIMARY KEY AUTOINCREMENT,
            id_user INTEGER,
            id_exercice INTEGER NOT NULL
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
>>>>>>> Stashed changes

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

// Modified DBHelper that uses web storage for web and SQLite for mobile
class DBHelper {
  // Your existing SQLite code here for mobile...
  
  static Future<void> registration(
    String username,
    String email,
    String password,
    double weight,
    double height,
    String birthDate,
    String gender,
  ) async {
    if (kIsWeb) {
      // Use web storage for web
      await WebStorageHelper.registration(username, email, password, weight, height, birthDate, gender);
    } else {
      // Use SQLite for mobile (your existing code)
      // ... your existing SQLite registration code
    }
  }
  
  static Future<bool> checkLogin(String email, String password) async {
    if (kIsWeb) {
      return await WebStorageHelper.checkLogin(email, password);
    } else {
      // Your existing SQLite login code
      return false; // Replace with your SQLite code
    }
  }
  
  static Future<Map<String, dynamic>?> retrieve_user(String email) async {
    if (kIsWeb) {
      return await WebStorageHelper.retrieve_user(email);
    } else {
      // Your existing SQLite code
      return null; // Replace with your SQLite code
    }
  }
  
  static Future<void> add_avatar(String email, String avatar) async {
    if (kIsWeb) {
      await WebStorageHelper.add_avatar(email, avatar);
    } else {
      // Your existing SQLite code
    }
  }
}