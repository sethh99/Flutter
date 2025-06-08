import 'package:flutter/material.dart';

// This relative path should correctly locate your AuthService.
import '../services/auth_service.dart';

// Import all necessary screens
import 'home_screen.dart';
import 'register_screen.dart';
import 'phone_verification_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    // Capture context-dependent objects before the async call for safety.
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final user = await AuthService.loginUser(
      _emailController.text,
      _passwordController.text,
    );

    // This check prevents errors if the widget is removed from the tree during the await.
    if (!mounted) return;

    if (user != null) {
      // Navigate directly to HomeScreen after a successful login.
      navigator.pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(user: user),
        ),
      );
    } else {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Invalid email or password.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _goToRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const RegisterScreen(),
      ),
    );
  }

  void _goToForgotPassword() {
    // Since the PhoneVerificationScreen expects a user map,
    // we pass a dummy map for the forgot password flow.
    final dummyUser = {
      "username": "Guest",
      "email": "",
      "password": ""
    };

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PhoneVerificationScreen(user: dummyUser),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Login'),
            ),
            // **NEW WIDGET: Row for Register and Forgot Password links**
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _goToRegister,
                  child: const Text("Don't have an account?"),
                ),
                TextButton(
                  onPressed: _goToForgotPassword,
                  child: const Text('Forgot Password?'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
