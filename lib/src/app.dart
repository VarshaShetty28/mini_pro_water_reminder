import 'package:flutter/material.dart';
import 'package:mini_pro_water_reminder/src/presentation/screens/onboarding/onboarding_flow.dart';
import 'package:mini_pro_water_reminder/src/presentation/screens/dashboard/dashboard_screen.dart';  // Import the dashboard screen

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
      initialRoute: '/onboarding',  // Set to onboarding as the first screen
      routes: {
        '/onboarding': (context) => const OnboardingFlow(),  // Add onboarding route
        '/dashboard': (context) => DashboardScreen(),  // Ensure this route is defined
        // Add more routes if needed
      },
    );
  }
}
