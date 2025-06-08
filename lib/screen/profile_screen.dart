import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  // Accept the user data map in the constructor
  final Map<String, dynamic> user;

  const ProfileScreen({super.key, required this.user});

  // Helper method to show an info dialog
  void _showInfoDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SelectableText(content), // Makes the content copyable
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          const SizedBox(height: 30),
          // Circle logo with user picture (placeholder)
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.black26,
            child: Icon(
              Icons.person_outline,
              size: 60,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          // Username fetched from the user data
          Text(
            user['username'] ?? 'No Username', // Use null-aware operator for safety
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          // Button to view email
          Card(
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.email_outlined),
              title: const Text('View Email'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _showInfoDialog(context, 'Email Address', user['email'] ?? 'Not available');
              },
            ),
          ),
          // Button to view password
          Card(
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('View Password'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // IMPORTANT: Displaying passwords in plain text is a major security risk.
                // This is for demonstration purposes only.
                _showInfoDialog(context, 'Password (Unsecure)', user['password'] ?? 'Not available');
              },
            ),
          ),
        ],
      ),
    );
  }
}