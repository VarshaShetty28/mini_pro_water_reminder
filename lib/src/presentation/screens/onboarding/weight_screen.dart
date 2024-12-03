import 'package:flutter/material.dart';

class WeightScreen extends StatefulWidget {
  final Function(double) onNext;

  const WeightScreen({super.key, required this.onNext});

  @override
  _WeightScreenState createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  double weight = 60.0; // Default weight

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter Your Weight (kg)',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            // Increment/Decrement buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, size: 40),
                  onPressed: () {
                    setState(() {
                      if (weight > 30) {
                        weight--;
                      }
                    });
                  },
                ),
                Text(
                  '${weight.toInt()} kg',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, size: 40),
                  onPressed: () {
                    setState(() {
                      if (weight < 150) {
                        weight++;
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Slider to adjust weight
            Slider(
              value: weight,
              min: 30,
              max: 150,
              divisions: 120,
              label: '${weight.toInt()} kg',
              activeColor: Colors.blueAccent,
              inactiveColor: Colors.blue.shade200,
              onChanged: (double value) {
                setState(() {
                  weight = value;
                });
              },
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () => widget.onNext(weight),
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
