import 'package:flutter/material.dart';
import 'package:mini_pro_water_reminder/src/presentation/screens/onboarding/gender_screen.dart';
import 'package:mini_pro_water_reminder/src/presentation/screens/onboarding/age_screen.dart';
import 'package:mini_pro_water_reminder/src/presentation/screens/onboarding/weight_screen.dart';
import 'package:mini_pro_water_reminder/src/presentation/screens/onboarding/wakeup_screen.dart';
import 'package:mini_pro_water_reminder/src/presentation/screens/onboarding/bedtime_screen.dart';
import 'package:mini_pro_water_reminder/src/presentation/screens/dashboard/dashboard_screen.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  final List<String> _titles = [
    "Select Gender",
    "Enter Age",
    "Enter Weight",
    "Wakeup Time",
    "Bedtime",
  ];

  final String _motivation = "Stay hydrated, stay healthy!";

  void _nextStep() {
    if (_currentStep < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentStep++;
      });
    } else {
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top Section with Back Arrow, Title, and Motivation
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 30),
            decoration: const BoxDecoration(
              color: Colors.blue, // Blue background
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    // Back Arrow Button
                    if (_currentStep > 0)
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: _previousStep,
                      ),
                    const SizedBox(width: 10),

                    // Title
                    Expanded(
                      child: Text(
                        _titles[_currentStep],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Placeholder to align title centrally
                    if (_currentStep > 0)
                      const SizedBox(
                        width: 48, // Match back arrow button's width
                      ),
                  ],
                ),
                const SizedBox(height: 20),

                // Motivational Thought
                Text(
                  _motivation,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Content Area with PageView
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                GenderScreen(onNext: (gender) => _nextStep()),
                AgeScreen(onNext: (age) => _nextStep()),
                WeightScreen(onNext: (weight) => _nextStep()),
                WakeupScreen(onNext: (wakeupTime) => _nextStep()),
                BedtimeScreen(onNext: (bedtime) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const DashboardScreen(),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
