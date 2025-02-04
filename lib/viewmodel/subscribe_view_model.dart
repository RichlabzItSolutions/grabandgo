import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SubscribeViewModel extends ChangeNotifier {
  int quantity = 1;
  String selectedFrequency = "Everyday";
  DateTime selectedDate = DateTime.now(); // Default to today's date
  TimeOfDay selectedTime = TimeOfDay(hour: 5, minute: 0); // Default time

  void incrementQuantity() {
    quantity++;
  }

  void decrementQuantity() {
    if (quantity > 1) quantity--;
  }

  void setSelectedDate(DateTime date) {
    selectedDate = date;
  }

  void setSelectedTime(TimeOfDay time) {
    selectedTime = time;
  }
}
