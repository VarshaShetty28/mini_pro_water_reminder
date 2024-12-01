import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mini_pro_water_reminder/src/presentation/screens/splash/splash_screen.dart'; // Adjust the import based on your structure
import 'package:firebase_auth/firebase_auth.dart';  // Import FirebaseAuth

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with the options file generated by FlutterFire CLI
  await Firebase.initializeApp();

  // Sign out any existing user (if logged in)
  //await FirebaseAuth.instance.signOut();

  runApp(const WaterReminderApp());
}

class WaterReminderApp extends StatelessWidget {
  const WaterReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Water Reminder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),  // Set the SplashScreen as the home widget
    );
  }
}
