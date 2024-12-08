import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mini_pro_water_reminder/src/presentation/screens/onboarding/gender_screen.dart';
import 'package:mini_pro_water_reminder/src/presentation/screens/onboarding/age_screen.dart';
import 'package:mini_pro_water_reminder/src/presentation/screens/onboarding/weight_screen.dart';
import 'package:mini_pro_water_reminder/src/presentation/screens/onboarding/wakeup_screen.dart';
import 'package:mini_pro_water_reminder/src/presentation/screens/onboarding/bedtime_screen.dart';
import 'package:mini_pro_water_reminder/src/presentation/screens/onboarding/kidney_stone_report.dart';
import 'package:mini_pro_water_reminder/src/presentation/screens/dashboard/dashboard_screen.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Titles for each step
  final List<String> _titles = [
    "Select Gender",
    "Enter Age",
    "Enter Weight",
    "Wakeup Time",
    "Bedtime",
    "Upload Kidney Stone Report",
  ];

  final String _motivation = "Stay hydrated, stay healthy!";

  // User data variables
  String? _gender;
  int? _age;
  double? _weight;
  String? _wakeupTime;
  String? _bedtime;
  String? _kidneyStoneReport;

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firestore save logic
  Future<void> saveUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;

    // Ensure the user is authenticated
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not authenticated")),
      );
      return;
    }

    final String userId = user.uid; // Get the user's UID

    // Create the user data map
    final Map<String, dynamic> userData = {
      'gender': _gender,
      'age': _age,
      'weight': _weight,
      'wakeupTime': _wakeupTime,
      'bedtime': _bedtime,
      'kidneyStoneReport': _kidneyStoneReport ?? '', // Optional field
      'createdAt': Timestamp.now(),
    };

    try {
      // Save the user data to Firestore under the user's UID
      await _firestore.collection('users').doc(userId).set(userData);

      // Navigate to the dashboard screen after successfully saving the data
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      }
    } catch (error) {
      // Handle any errors
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error saving data: $error")),
        );
      }
    }
  }

  void _nextStep() {
    if (_currentStep < _titles.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentStep++;
        debugPrint('Navigated to step $_currentStep: ${_titles[_currentStep]}');
      });
    } else {
      // Save data when the last step is completed
      saveUserData();
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
        debugPrint('Returned to step $_currentStep: ${_titles[_currentStep]}');
      });
    }
  }

  void _handleReportSubmission(String reportPath) {
    setState(() {
      _kidneyStoneReport = reportPath;
    });
    _nextStep();
  }

  void _handleSkipReport() {
    _kidneyStoneReport = null; // Explicitly set to null when skipped
    _nextStep();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
                top: 50, left: 16, right: 16, bottom: 30),
            decoration: const BoxDecoration(
              color: Colors.blue,
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
                    if (_currentStep > 0)
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: _previousStep,
                      ),
                    const SizedBox(width: 10),
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
                    const SizedBox(width: 48), // Aligning the title centrally
                  ],
                ),
                const SizedBox(height: 20),
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
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                GenderScreen(onNext: (gender) {
                  setState(() {
                    _gender = gender;
                  });
                  _nextStep();
                }),
                AgeScreen(onNext: (age) {
                  setState(() {
                    _age = age;
                  });
                  _nextStep();
                }),
                WeightScreen(onNext: (weight) {
                  setState(() {
                    _weight = weight;
                  });
                  _nextStep();
                }),
                WakeupScreen(onNext: (TimeOfDay selectedTime) {
                  setState(() {
                    _wakeupTime = selectedTime.format(context);
                  });
                  _nextStep();
                }),
                BedtimeScreen(onNext: (TimeOfDay selectedTime) {
                  setState(() {
                    _bedtime = selectedTime.format(context);
                  });
                  _nextStep();
                }),
                KidneyStoneReportScreen(
                  onSkip: _handleSkipReport,
                  onBack: _previousStep,
                  onSubmit: _handleReportSubmission,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
