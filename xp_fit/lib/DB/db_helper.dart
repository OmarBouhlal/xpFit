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
    final int _databaseVersion = 10;
    String path = join(await getDatabasesPath(), 'users.db');
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE user_exercices (
            id_exercice_user INTEGER PRIMARY KEY AUTOINCREMENT,
            id_user INTEGER ,
            id_exercice INTEGER,
            name_exercice TEXT NOT NULL,
            gifUrl TEXT,
            instructions TEXT,
          );
        ''');
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
            obj_weight REAL
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
          CREATE TABLE user_meals (
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
            id_user_obj PRIMARY KEY AUTOINCREMENT,
            id_obj INTEGER NOT NULL ,
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
    );
  }

  static Future<void> addAvatar(String email, String avatarPath) async {
    final db = await database;

    // First get the user ID from email
    final user = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    if (user.isEmpty) {
      throw Exception('User not found');
    }

    final userId = user.first['id_user'] as int;

    // Check if avatar column exists, if not add it
    final columns = await db.rawQuery('PRAGMA table_info(users)');
    final hasAvatarColumn = columns.any((col) => col['name'] == 'avatar');

    if (!hasAvatarColumn) {
      await db.execute('ALTER TABLE users ADD COLUMN avatar TEXT');
    }

    // Update the user's avatar
    await db.update(
      'users',
      {'avatar': avatarPath},
      where: 'id_user = ?',
      whereArgs: [userId],
    );
  }

  static Future<void> registration(
    String username,
    String email,
    String password,
    double? weight,
    double? height,
    String? birthDate,
    String? gender,
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

  static Future<List<Map<String, dynamic>>> getFavorites(
    String selectedFilter,
    String email,
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
    int id_exercice,
    String name_exercice,
    String? gifUrl,
    String instructions,
  ) async {
    final db = await database;
    final user = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    final userId = user.first['id_user'] as int;
    await db.insert('user_exercices', {
      'id_user': userId,
      'id_exercice': id_exercice,
      'name_exercice': name_exercice,
      'gifUrl': gifUrl,
      'instructions': instructions,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
