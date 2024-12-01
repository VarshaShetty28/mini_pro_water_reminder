import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Sample data - in real app, this would come from backend
  final double dailyTarget = 1260;
  double currentIntake = 250;
  final List<WaterRecord> records = [
    WaterRecord(time: "10:44 pm", amount: 125),
    WaterRecord(time: "10:43 pm", amount: 125),
  ];
  String nextTime = "06:00 am";

  void addWaterIntake() {
    setState(() {
      if (currentIntake < dailyTarget) {
        currentIntake += 125;
        records.insert(0, WaterRecord(
          time: "${DateTime.now().hour}:${DateTime.now().minute}",
          amount: 125,
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2196F3),
        elevation: 0,
        title: const Row(
          children: [
            Text(
              'Home',
              style: TextStyle(color: Colors.white),
            ),
            Spacer(),
            Icon(Icons.history, color: Colors.white60),
            SizedBox(width: 20),
            Icon(Icons.settings, color: Colors.white60),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Mascot and message
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.water_drop,
                        color: Colors.blue,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Text(
                          'Drink your glass of water slowly with some small sips',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // Progress circle
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: CircularProgressIndicator(
                        value: currentIntake / dailyTarget,
                        strokeWidth: 10,
                        backgroundColor: Colors.grey[200],
                        color: Colors.blue,
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          '${currentIntake.toInt()}/${dailyTarget.toInt()}ml',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Daily Drink Target',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Add water button
                GestureDetector(
                  onTap: addWaterIntake,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.local_drink, color: Colors.blue[300]),
                        const SizedBox(width: 5),
                        Text(
                          '125 ml',
                          style: TextStyle(color: Colors.blue[300]),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Confirm that you have just drunk water',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          // Records section
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Today's records",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                // Next time
                Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.grey),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nextTime,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Text('Next time', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    const Spacer(),
                    Text('125 ml', style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
                const Divider(),
                // Records list
                ...records.map((record) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.local_drink, color: Colors.blue),
                      const SizedBox(width: 10),
                      Text(record.time),
                      const Spacer(),
                      Text('${record.amount} ml'),
                    ],
                  ),
                )).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WaterRecord {
  final String time;
  final int amount;

  WaterRecord({required this.time, required this.amount});
}