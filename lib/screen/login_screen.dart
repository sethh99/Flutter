import 'package:flutter/material.dart';
import 'home_screen.dart'; // Make sure this path is correct
import 'register_screen.dart'; // Make sure this path is correct
import 'package:flutter/gestures.dart'; // Already imported

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // New: Global key for the form
  final TextEditingController _emailController = TextEditingController(); // Changed to email
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  void _login() {
    if (_formKey.currentState!.validate()) { // New: Trigger form validation

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(username: _emailController.text.split('@')[0]), // Use email part as username
        ),
      );
    }
  }

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
        child: Form( // New: Wrap content in a Form widget
          key: _formKey, // Assign the global key to the form
          child: Column(
            children: [
              const Spacer(),
              const Text(
                'Welcome Back!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              TextFormField( // Changed to TextFormField
                controller: _emailController,
                keyboardType: TextInputType.emailAddress, // Suggest email keyboard
                decoration: const InputDecoration(
                  labelText: 'Email', // Changed label to Email
                  prefixIcon: Icon(Icons.email), // Changed icon to email
                  border: OutlineInputBorder(),
                ),
                validator: _validateEmail, // Assign validator function
              ),
              const SizedBox(height: 16),
              TextFormField( // Changed to TextFormField
                controller: _passwordController,
                obscureText: !_isPasswordVisible, // Control visibility
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton( // New: Suffix icon for password visibility
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible; // Toggle visibility
                      });
                    },
                  ),
                ),
                validator: _validatePassword, // Assign validator function
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Login'),
              ),
              const Spacer(),
              RichText(
                text: TextSpan(
                  text: "Don't have an account? ",
                  style: const TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: 'Register.',
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = _goToRegister,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}