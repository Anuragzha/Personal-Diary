import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Note: You must run 'flutterfire configure' to generate this file
import 'firebase_options.dart';
import 'login.dart';
import 'signup.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Diary',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.purpleAccent,
        fontFamily: 'Poppins',
      ),
      // Uses StreamBuilder to manage navigation based on login status
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // If user data exists, navigate to Home
          if (snapshot.hasData) {
            return const HomePage();
          }
          // Otherwise, navigate to Login
          return const LoginPage();
        },
      ),
      // Define routes for navigation (used for the "Login/Sign Up" text buttons)
      routes: {
        '/login': (context) => const LoginPage(),
        // Removed 'const' because SignupPage uses a Ticker for animation
        '/signup': (context) => SignupPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
