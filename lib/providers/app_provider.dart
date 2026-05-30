import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  String userName = "Fad";
  int cycleDay = 20;
  int nextPeriod = 8;

  void updateName(String name) {
    userName = name;
    notifyListeners();
  }

  void updateCycle(int day) {
    cycleDay = day;
    notifyListeners();
  }

  void updateNextPeriod(int days) {
    nextPeriod = days;
    notifyListeners();
  }
}