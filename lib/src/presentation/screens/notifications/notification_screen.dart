import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationModel {
  String time;
  bool isEnabled;

  NotificationModel({required this.time, this.isEnabled = false});
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationModel> recommendedTimes = [];
  bool _isLoading = true;
  String? _errorMessage;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadNotificationData();
  }

  Future<void> _loadNotificationData() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _handleError('No user logged in');
        return;
      }

      // Fetch user document
      final DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        _handleError('User document not found');
        return;
      }

      // Extract data from user document
      final Map<String, dynamic>? userData =
      userDoc.data() as Map<String, dynamic>?;

      if (userData == null) {
        _handleError('User data is empty');
        return;
      }

      // Get wakeup and bedtime
      final String? wakeupTime = userData['wakeupTime'];
      final String? bedtime = userData['bedtime'];

      // Get stored notification times or generate default times
      final List<dynamic>? storedTimes = userData['notificationTimes'];

      if (storedTimes != null && storedTimes.isNotEmpty) {
        // Use stored times
        setState(() {
          recommendedTimes = storedTimes
              .map((time) => NotificationModel(
            time: time.toString(),
            isEnabled: false,
          ))
              .toList();
          _isLoading = false;
        });
      } else if (wakeupTime != null && bedtime != null) {
        // Generate default times if no stored times
        _generateDefaultNotificationTimes(wakeupTime, bedtime);
      } else {
        _handleError('Missing wakeup or bedtime information');
      }
    } catch (e) {
      _handleError('Error loading notification data: ${e.toString()}');
    }
  }

  void _generateDefaultNotificationTimes(String wakeupTime, String bedtime) {
    try {
      // Parse 12-hour time with AM/PM
      final DateTime wakeupDateTime = _parseTime(wakeupTime);
      final DateTime bedtimeDateTime = _parseTime(bedtime);

      // Calculate the total duration in minutes between wakeup and bedtime
      final Duration duration = bedtimeDateTime.difference(wakeupDateTime);
      final int totalMinutes = duration.inMinutes;

      // Define the number of recommendations (13)
      const int minRecommendations = 13;
      const int maxRecommendations = 13;
      final int recommendations =
          minRecommendations + (totalMinutes % (maxRecommendations - minRecommendations + 1));

      // Calculate the interval in minutes for the notifications
      final int intervalMinutes = totalMinutes ~/ recommendations;

      // Generate notification times
      List<NotificationModel> times = [];
      for (int i = 0; i < recommendations; i++) {
        final DateTime notificationTime =
        wakeupDateTime.add(Duration(minutes: i * intervalMinutes));
        final String formattedTime =
        _formatTime(notificationTime.hour, notificationTime.minute);
        times.add(NotificationModel(time: formattedTime, isEnabled: true));
      }

      setState(() {
        recommendedTimes = times;
        _isLoading = false;
      });

      // Save generated times to Firestore
      _saveNotificationTimes(times);
    } catch (e) {
      _handleError('Error generating notification times: ${e.toString()}');
    }
  }

  DateTime _parseTime(String timeString) {
    // Parse 12-hour time with AM/PM
    final timeFormat = RegExp(r'(\d+):(\d+)\s*(AM|PM)');
    final match = timeFormat.firstMatch(timeString);

    if (match == null) {
      throw FormatException('Invalid time format: $timeString');
    }

    int hour = int.parse(match.group(1)!);
    final minute = int.parse(match.group(2)!);
    final period = match.group(3)!;

    // Adjust hour for PM
    if (period.toUpperCase() == 'PM' && hour != 12) {
      hour += 12;
    }
    // Adjust hour for 12 AM
    if (period.toUpperCase() == 'AM' && hour == 12) {
      hour = 0;
    }

    return DateTime(2024, 1, 1, hour, minute);
  }

  String _formatTime(int hour, int minute) {
    // Convert 24-hour time to 12-hour format with AM/PM
    final periodIndicator = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final formattedMinute = minute.toString().padLeft(2, '0');
    return '$displayHour:$formattedMinute $periodIndicator';
  }

  void _handleError(String message) {
    setState(() {
      _isLoading = false;
      _errorMessage = message;
      recommendedTimes = [];
    });

    // Show error snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _saveNotificationTimes(List<NotificationModel> times) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final List<String> timesToSave =
      times.map((notification) => notification.time).toList();

      await _firestore
          .collection('users')
          .doc(user.uid)
          .update({'notificationTimes': timesToSave});
    } catch (error) {
      _handleError('Error saving notification times: ${error.toString()}');
    }
  }

  void _addCustomNotificationTime() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((selectedTime) {
      if (selectedTime != null) {
        final formattedTime = selectedTime.format(context);
        setState(() {
          recommendedTimes.add(
            NotificationModel(time: formattedTime, isEnabled: false),
          );
        });
        _saveNotificationTimes(recommendedTimes);
      }
    });
  }

  void _deleteNotificationTime(int index) {
    setState(() {
      recommendedTimes.removeAt(index);
    });
    _saveNotificationTimes(recommendedTimes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notification Settings',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error Loading Notifications',
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
            ElevatedButton(
              onPressed: _loadNotificationData,
              child: Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,  // Use backgroundColor instead of primary
              ),
            ),
          ],
        ),
      )
          : recommendedTimes.isEmpty
          ? Center(
        child: Text(
          'No notification times available',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: recommendedTimes.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(Icons.alarm, color: Colors.blue),
              title: Text(
                recommendedTimes[index].time,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch(
                    value: recommendedTimes[index].isEnabled,
                    onChanged: (bool value) {
                      setState(() {
                        recommendedTimes[index].isEnabled = value;
                      });
                    },
                    activeColor: Colors.blue, // Blue color for enabled state
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteNotificationTime(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCustomNotificationTime,
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
