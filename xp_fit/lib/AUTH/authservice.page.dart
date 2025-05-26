import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _loggedInEmail;
  String? _username;
  String? _avatarPath;

  String? get loggedInEmail => _loggedInEmail;
  String? get username => _username;
  String? get avatarPath => _avatarPath;

  Future<void> loadStoredUser() async {
    final prefs = await SharedPreferences.getInstance();
    _loggedInEmail = prefs.getString('logged_in_email');
    _username = prefs.getString('username');
    _avatarPath = prefs.getString('user_avatar'); // Load saved avatar
    notifyListeners();
  }

  Future<void> setLoggedInUser({
    required String email,
    required String username,
    String? avatarPath,
  }) async {
    _loggedInEmail = email;
    _username = username;
    _avatarPath = avatarPath;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('logged_in_email', email);
    await prefs.setString('username', username);

    // Only save avatar if provided
    if (avatarPath != null) {
      await prefs.setString('user_avatar', avatarPath);
    }

    notifyListeners();
  }

  Future<void> logout() async {
    _loggedInEmail = null;
    _username = null;
    _avatarPath = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('logged_in_email');
    await prefs.remove('username');
    await prefs.remove('user_avatar'); // Clear avatar on logout

    notifyListeners();
  }

  Future<void> setAvatar(String avatarPath) async {
    _avatarPath = avatarPath;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_avatar', avatarPath);

    notifyListeners();
  }

  Future<void> clearAvatar() async {
    _avatarPath = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_avatar');

    notifyListeners();
  }
}
