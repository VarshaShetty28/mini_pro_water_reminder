import 'package:flutter/material.dart';

class WakeupScreen extends StatelessWidget {
  final Function(TimeOfDay) onNext;

  const WakeupScreen({
    super.key,  // Use super.key directly
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final TimeOfDay selectedTime = TimeOfDay.now();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select Wake-Up Time',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: selectedTime,
                );
                if (pickedTime != null) {
                  onNext(pickedTime);
                }
              },
              child: const Text('Pick Time'),
            ),
          ],
        ),
      ),
    );
  }
}