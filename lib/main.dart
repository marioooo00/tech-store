import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'splash_screen.dart';
import 'login_screen.dart';
import 'sign_up.dart';
import 'home_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(

    options:
        DefaultFirebaseOptions
            .currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      theme: ThemeData(

        colorScheme:
            ColorScheme.fromSeed(

          seedColor:
              Colors.deepPurple,
        ),
      ),

      // =========================
      // START SCREEN
      // =========================
      home: const SplashScreen(),

      // =========================
      // ROUTES
      // =========================
      routes: {

        '/login': (context) =>
            const LoginScreen(),

        '/signup': (context) =>
            const SignUpScreen(),

        '/home': (context) =>
            const HomeScreen(),
      },
    );
  }
}