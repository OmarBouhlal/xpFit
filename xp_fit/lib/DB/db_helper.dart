import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
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

  static Future<void> registration(
    String username,
    String email,
    String password,
    double weight,
    double height,
    String birthDate,
    String gender,
  ) async {
    final db = await database;
    await db.insert('users', {
      'username': username,
      'email': email,
      'password': password,
      'weight': weight,
      'height': height,
      'birthDate': birthDate,
      'gender': gender,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<bool> checkLogin(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty;
  }  
  
  static Future<void> add_avatar(String email, String avatar) async {    
    final db = await database;
    await db.update(
      'users',
      {'avatar': avatar},
      where: 'email = ?',
      whereArgs: [email]
    );
  }

  // Helper method to reset database (for development/testing)
  static Future<void> resetDatabase() async {
    String path = join(await getDatabasesPath(), 'users.db');
    await deleteDatabase(path);
    _db = null;
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


  //modify the Current weight
  static Future<void> modifyCurrentWeight(String email, double weight) async {
    final db = await database;

    try{
      final result = await db.update('users', {'weight': weight}, where: 'email = ?' ,  whereArgs: [email]);
    }
    catch(e){
      print('Error fetching favorites: $e');
    }
  }

    //modify the Objective weight
  static Future<void> modifyObjeeWeight(String email, double obj_weight) async {
    final db = await database;

    try{
      final result = await db.update('users', {'obj_weight': obj_weight}, where: 'email = ?' ,  whereArgs: [email]);
    }
    catch(e){
      print('Error fetching favorites: $e');
    }
  }


  //get the current weight from db 
  static Future<double> getCurrentWeight(
    String? email) async {
    final db = await database;
    try {
      final user = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
        limit: 1,
      );
      final currentWeight = user.first['weight'] as double;
      return currentWeight;
    } catch (e) {
      print('Error fetching current weight: $e');
      rethrow; // Re-throw the error to handle it in the calling code
    }
  }

    //get the current weight from db 
  static Future<double> getObjtWeight(
    String? email) async {
    final db = await database;
    try {
      final user = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
        limit: 1,
      );
      if(user.first['obj_weight']!=null){
        return user.first['obj_weight'] as double;
      }
      else{
         return 5.0;
      }
    } catch (e) {
      print('Error fetching current weight: $e');
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
