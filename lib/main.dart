import 'package:flutter/material.dart';
import 'package:w2pro/screen/login_screen.dart';
import 'package:w2pro/screen/register_screen.dart';
import 'package:w2pro/screen/home_screen.dart';

void main() {
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Screen',
      home: LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        // HomeScreen needs a parameter, so we won't define it here directly.
      },
    );
  }
}
