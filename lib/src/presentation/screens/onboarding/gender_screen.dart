import 'package:flutter/material.dart';

class GenderScreen extends StatelessWidget {
  final Function(String) onNext;

  const GenderScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
      //  title: const Text('Select Your Gender'),
      //  centerTitle: true,
      //  backgroundColor: Colors.blue,
      //  elevation: 2,
      //),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            const Text(
              'Select Your Gender',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30), // Space between title and icons

            // Gender Selection
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Male Option
                GestureDetector(
                  onTap: () => onNext('Male'),
                  child: Column(
                    children: const [
                      Icon(Icons.male, size: 100, color: Colors.blue),
                      SizedBox(height: 10), // Space between icon and text
                      Text(
                        'Male',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 50), // Space between male and female

                // Female Option
                GestureDetector(
                  onTap: () => onNext('Female'),
                  child: Column(
                    children: const [
                      Icon(Icons.female, size: 100, color: Colors.pink),
                      SizedBox(height: 10), // Space between icon and text
                      Text(
                        'Female',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
