import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// For web, use a simple in-memory storage
// For mobile, use SQLite (you'll need to keep your original SQLite code for mobile)

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