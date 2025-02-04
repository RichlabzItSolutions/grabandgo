class NotificationModel {
  final String description;
  final String time;
  final String type; // Determines the icon type
  final DateTime date; // Date for grouping notifications
  bool isRead;
  NotificationModel({
    required this.description,
    required this.time,
    required this.type,
    required this.date,
    this.isRead = false,
  });
}
