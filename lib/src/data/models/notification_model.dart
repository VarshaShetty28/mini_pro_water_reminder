// lib/src/data/models/notification_model.dart
class NotificationModel {
  String time;  // Example: '08:00 AM'
  bool isEnabled; // Is the notification enabled

  NotificationModel({
    required this.time,
    this.isEnabled = true,
  });
}
