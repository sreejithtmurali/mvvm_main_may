import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/User.dart';


class UserService {
  static const String _userKey = "USER_SESSION";

  /// Save user session
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(user.toJson());
    await prefs.setString(_userKey, userJson);
  }

  /// Get user session
  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString(_userKey);
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_userKey);
  }

  /// Get access token
  Future<String?> getAccessToken() async {
    final user = await getUser();
    return user?.access;
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    final user = await getUser();
    return user?.refresh;
  }

  /// Logout (clear user session)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
