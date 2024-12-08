import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_pro_water_reminder/src/presentation/screens/notifications/notification_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double currentIntake = 0;
  final List<WaterRecord> records = [];

  // User data variables
  double weight = 0.0;
  int age = 0;
  String gender = "";
  double dailyTarget = 0.0;
  bool isLoading = true;

  // Current page index for bottom navigation
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchUserDataAndCalculateIntake();
  }

  /// Fetch user data and calculate daily water intake
  Future<void> fetchUserDataAndCalculateIntake() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      // Fetch user document
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          weight = (userDoc['weight'] as num).toDouble();
          age = userDoc['age'] as int;
          gender = userDoc['gender'] as String;

          // Calculate daily water intake
          dailyTarget = calculateWaterIntake();
        });

        // Fetch today's water intake records
        await fetchTodayWaterIntakeRecords();
      } else {
        throw Exception("User document not found");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Calculate daily water intake based on user details
  double calculateWaterIntake() {
    const double waterIntakePerKg = 32.5;

    // Adjust based on age
    double ageFactor = 1.0;
    if (age < 18) {
      ageFactor = 1.05;
    } else if (age >= 50) {
      ageFactor = 0.95;
    }

    // Adjust based on gender
    double genderFactor = gender.toLowerCase() == 'male' ? 1.05 : 0.95;

    // Final calculation
    return weight * waterIntakePerKg * ageFactor * genderFactor;
  }

  /// Fetch water intake records for today
  Future<void> fetchTodayWaterIntakeRecords() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      DateTime today = DateTime.now();
      DateTime startOfDay = DateTime(today.year, today.month, today.day);

      QuerySnapshot recordsSnapshot = await FirebaseFirestore.instance
          .collection('water_intake')
          .where('userId', isEqualTo: currentUser.uid)
          .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .orderBy('timestamp', descending: true)
          .get();

      setState(() {
        records.clear();
        records.addAll(recordsSnapshot.docs.map((doc) => WaterRecord(
          time: _formatTimestamp(doc['timestamp'] as Timestamp),
          amount: doc['amount'] as int,
        )));

        // Update current intake from records
        currentIntake = records.fold(0, (sum, record) => sum + record.amount);
      });
    } catch (e) {
      print("Error fetching water intake records: $e");
    }
  }

  /// Add water intake record
  Future<void> addWaterIntake() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      if (currentIntake < dailyTarget) {
        const intakeAmount = 125;

        // Add new record to Firestore
        await FirebaseFirestore.instance.collection('water_intake').add({
          'userId': currentUser.uid,
          'amount': intakeAmount,
          'timestamp': Timestamp.now(),
        });

        // Fetch updated records
        await fetchTodayWaterIntakeRecords();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You have already reached your daily target!")),
        );
      }
    } catch (e) {
      print("Error adding water intake: $e");
    }
  }

  /// Format Firestore timestamp to a readable time
  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  /// Handle bottom navigation bar tap
  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });

    // Navigate to other pages based on index
    switch (index) {
      case 0:
      // Stay on the dashboard
        break;
      case 1:
      // Navigate to analysis page (implement separately)
        break;
      case 2:
      // Navigate to notifications page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  NotificationScreen()),
        );
        break;
      case 3:
      // Navigate to settings page (implement separately)
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2196F3),
        elevation: 0,
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 30),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: CircularProgressIndicator(
                        value: (currentIntake / dailyTarget).clamp(0, 1),
                        strokeWidth: 10,
                        backgroundColor: Colors.grey[200],
                        color: Colors.blue,
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          '${currentIntake.toInt()}/${dailyTarget.toInt()} ml',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Daily Drink Target',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
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
                          'Add 125 ml',
                          style: TextStyle(color: Colors.blue[300]),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Today's Records",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: records.length,
                      itemBuilder: (context, index) {
                        final record = records[index];
                        return ListTile(
                          leading: const Icon(Icons.local_drink, color: Colors.blue),
                          title: Text(record.time),
                          trailing: Text('${record.amount} ml'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTabTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Analysis'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
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
