import 'package:flutter/material.dart';

class AgeScreen extends StatelessWidget {
  final Function(int) onNext;

  const AgeScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    ValueNotifier<int> selectedAge = ValueNotifier<int>(25); // Default age

    return Scaffold(
      //appBar: AppBar(
      //  title: const Text('Select Your Age'),
      //  backgroundColor: Colors.blue,
      //  centerTitle: true,
      //  elevation: 2,
     // ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30), // Space before title

            // Title
            const Text(
              'How old are you?',

              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10), // Space after title
            const Text(
              'Please scroll to select your age',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40), // Space before picker

            // Scrollable Number Picker with Enhanced UI
            SizedBox(
              height: 200,
              child: ListWheelScrollView.useDelegate(
                physics: const FixedExtentScrollPhysics(),
                itemExtent: 60,
                perspective: 0.002,
                diameterRatio: 1.8,
                onSelectedItemChanged: (index) {
                  selectedAge.value = index + 10; // Age starts from 10
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  builder: (context, index) {
                    bool isSelected = (index + 10 == selectedAge.value);
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blueAccent : Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Center(
                        child: Text(
                          '${index + 10}',
                          style: TextStyle(
                            fontSize: isSelected ? 28 : 22,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: 91, // Numbers from 10 to 100
                ),
              ),
            ),

            const SizedBox(height: 20), // Space before selected age display

            // Display Selected Age Dynamically
            ValueListenableBuilder<int>(
              valueListenable: selectedAge,
              builder: (context, value, child) {
                return Text(
                  'Selected Age: $value',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                );
              },
            ),
            const SizedBox(height: 40), // Space before button

            // Next Button with Animation
            ElevatedButton(
              onPressed: () => onNext(selectedAge.value),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
