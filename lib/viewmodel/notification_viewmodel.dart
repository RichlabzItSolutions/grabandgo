import 'package:flutter/material.dart';
import '../data/model/notification_model.dart';


class NotificationViewModel extends ChangeNotifier {
  final List<NotificationModel> _notifications = [
    NotificationModel(
        description: "Your order has been shipped.",
        time: "1hr",
        type: "order",
        date: DateTime.now()), // Today

    NotificationModel(
        description: "Don't miss out on today's flash sale.",
        time: "1hr",
        type: "sale",
        date: DateTime.now()), // Today

    NotificationModel(
        description: "Please review your recent purchase.",
        time: "1hr",
        type: "review",
        date: DateTime.now().subtract(Duration(days: 1))), // Yesterday

    NotificationModel(
        description: "Your previous order has shipped.",
        time: "2d",
        type: "order",
        date: DateTime.now().subtract(Duration(days: 2))), // Earlier
  ];

  Map<String, List<NotificationModel>> get groupedNotifications {
    final today = DateTime.now();
    final yesterday = today.subtract(Duration(days: 1));

    final Map<String, List<NotificationModel>> grouped = {
      "Today": [],
      "Yesterday": [],
      "Earlier": []
    };

    for (var notification in _notifications) {
      if (_isSameDay(notification.date, today)) {
        grouped["Today"]!.add(notification);
      } else if (_isSameDay(notification.date, yesterday)) {
        grouped["Yesterday"]!.add(notification);
      } else {
        grouped["Earlier"]!.add(notification);
      }
    }
    return grouped;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void markSectionAsRead(String section) {
    groupedNotifications[section]?.forEach((notification) {
      notification.isRead = true;
    });
    notifyListeners(); // Notify listeners to rebuild the UI
  }
}
