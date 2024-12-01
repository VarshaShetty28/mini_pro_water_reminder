import 'package:flutter/material.dart';

class WeightScreen extends StatelessWidget {
  final Function(double) onNext;

  // Add `key` parameter and make the constructor `const`
  const WeightScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    double weight = 60.0; // Default weight

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter Your Weight (kg)',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            StatefulBuilder( // Use StatefulBuilder for local state updates
              builder: (context, setState) {
                return Slider(
                  value: weight,
                  min: 30,
                  max: 150,
                  divisions: 120,
                  label: '${weight.toInt()} kg',
                  onChanged: (double value) {
                    setState(() {
                      weight = value;
                    });
                  },
                );
              },
            ),
            ElevatedButton(
              onPressed: () => onNext(weight),
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
