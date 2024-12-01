import 'package:flutter/material.dart';
import 'package:mini_pro_water_reminder/src/presentation/screens/dashboard/dashboard_screen.dart';

class BedtimeScreen extends StatelessWidget {
  final Function(TimeOfDay) onNext;

  const BedtimeScreen({required this.onNext, super.key});

  @override
  Widget build(BuildContext context) {
    TimeOfDay selectedTime = TimeOfDay.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Bedtime'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select Bedtime',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: selectedTime,
                );

                if (pickedTime != null) {
                  onNext(pickedTime);
                  navigator.pushReplacement(
                      MaterialPageRoute(builder: (context) => const DashboardScreen())
                  );
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