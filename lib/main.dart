import 'package:flutter/material.dart';
import 'screen/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Use named routes for clean navigation
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the LoginScreen widget.
        '/': (context) => const LoginScreen(),
      },
    );
  }
}