import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AuthService {
  // This function reads the JSON and checks for the user
  static Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    // Immediately return null if either field is empty
    if (email.isEmpty || password.isEmpty) {
      return null;
    }

    try {
      final String response = await rootBundle.loadString('assets/db.json');
      final List<dynamic> data = json.decode(response);

      for (var user in data) {
        // Ensure we are working with a valid map and that credentials match
        if (user is Map<String, dynamic> &&
            user['email'] == email &&
            user['password'] == password) {
          return user; // Success: return the found user map
        }
      }
    } catch (e) {
      // Use debugPrint for development-only error logging
      if (kDebugMode) {
        debugPrint('Error reading or parsing db.json: $e');
      }
    }

    // Return null if no user was found or if an error occurred
    return null;
  }
}
