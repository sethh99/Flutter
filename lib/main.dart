import 'package:flutter/material.dart';
import 'screen/login_screen.dart';

// 1. IMPORT THE AUTH SERVICE
import 'services/auth_service.dart';

// 2. MAKE THE MAIN FUNCTION ASYNCHRONOUS
void main() async {
  // 3. ADD THESE TWO LINES TO INITIALIZE THE SERVICE
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.init();

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