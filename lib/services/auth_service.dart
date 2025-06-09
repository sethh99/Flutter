import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AuthService {
  // A static list to hold users in memory.
  static List<Map<String, dynamic>> _users = [];

  // Initializes the service by loading users from the JSON file into memory.
  // This should be called once when the app starts.
  static Future<void> init() async {
    try {
      final String response = await rootBundle.loadString('assets/db.json');
      final List<dynamic> data = json.decode(response);
      // Ensure all items are of the correct type.
      _users = data.whereType<Map<String, dynamic>>().toList();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error reading or parsing db.json: $e');
      }
      _users = []; // Start with an empty list if JSON is invalid or not found.
    }
  }

  // Registers a new user by adding them to the in-memory list.
  static Future<void> registerUser(Map<String, dynamic> newUser) async {
    // Optional: You could add a check here to prevent duplicate emails.
    _users.add(newUser);
    if (kDebugMode) {
      print('User registered. Current user count: ${_users.length}');
    }
  }

  // Logs a user in by checking the in-memory list.
  static Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return null;
    }

    // Find the user in the _users list.
    final user = _users.firstWhere(
          (user) => user['email'] == email && user['password'] == password,
      orElse: () => {}, // Return an empty map if no user is found.
    );

    // If the found user map is not empty, the login is successful.
    return user.isNotEmpty ? user : null;
  }
}