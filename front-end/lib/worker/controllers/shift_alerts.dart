import 'package:flutter/material.dart';

class WorkerShiftAlertsController extends ChangeNotifier {
  List<Map<String, dynamic>> shiftAlerts = [];
  DateTime? lastGeneratedDate;

  static const int shiftStartHour = 9;
  static const int shiftStartMinute = 0;
  static const int firstBreakHour = 11;
  static const int firstBreakMinute = 0;
  static const int lunchBreakStartHour = 12;
  static const int lunchBreakStartMinute = 30;
  static const int secondBreakHour = 16;
  static const int secondBreakMinute = 0;
  static const int shiftEndHour = 18;
  static const int shiftEndMinute = 0;
  static const int notificationAdvanceMinutes = 15;

  void generateDailySchedule() {
    clearIfNewDay();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    shiftAlerts.clear();
    lastGeneratedDate = today;

    final shiftStartTime = DateTime(today.year, today.month, today.day, shiftStartHour, shiftStartMinute);
    final shiftStartAlertTime = shiftStartTime.subtract(const Duration(minutes: notificationAdvanceMinutes));
    if (now.isAfter(shiftStartAlertTime) || now.isAtSameMomentAs(shiftStartAlertTime)) {
      shiftAlerts.add({
        'type': 'shiftStart',
        'message': 'Your shift starts at 9:00 AM',
        'timestamp': shiftStartAlertTime,
        'scheduledTime': shiftStartTime,
      });
    }

    final firstBreakTime = DateTime(today.year, today.month, today.day, firstBreakHour, firstBreakMinute);
    final firstBreakAlertTime = firstBreakTime.subtract(const Duration(minutes: notificationAdvanceMinutes));
    if (now.isAfter(firstBreakAlertTime) || now.isAtSameMomentAs(firstBreakAlertTime)) {
      shiftAlerts.add({
        'type': 'breakTime',
        'message': 'First break at 11:00 AM',
        'timestamp': firstBreakAlertTime,
        'scheduledTime': firstBreakTime,
      });
    }

    final lunchBreakTime = DateTime(today.year, today.month, today.day, lunchBreakStartHour, lunchBreakStartMinute);
    final lunchBreakAlertTime = lunchBreakTime.subtract(const Duration(minutes: notificationAdvanceMinutes));
    if (now.isAfter(lunchBreakAlertTime) || now.isAtSameMomentAs(lunchBreakAlertTime)) {
      shiftAlerts.add({
        'type': 'lunchBreak',
        'message': 'Lunch break at 12:30 PM',
        'timestamp': lunchBreakAlertTime,
        'scheduledTime': lunchBreakTime,
      });
    }

    final secondBreakTime = DateTime(today.year, today.month, today.day, secondBreakHour, secondBreakMinute);
    final secondBreakAlertTime = secondBreakTime.subtract(const Duration(minutes: notificationAdvanceMinutes));
    if (now.isAfter(secondBreakAlertTime) || now.isAtSameMomentAs(secondBreakAlertTime)) {
      shiftAlerts.add({
        'type': 'secondBreak',
        'message': 'Second break at 4:00 PM',
        'timestamp': secondBreakAlertTime,
        'scheduledTime': secondBreakTime,
      });
    }

    final shiftEndTime = DateTime(today.year, today.month, today.day, shiftEndHour, shiftEndMinute);
    final shiftEndAlertTime = shiftEndTime.subtract(const Duration(minutes: notificationAdvanceMinutes));
    if (now.isAfter(shiftEndAlertTime) || now.isAtSameMomentAs(shiftEndAlertTime)) {
      shiftAlerts.add({
        'type': 'shiftEnd',
        'message': 'Shift ends at 6:00 PM',
        'timestamp': shiftEndAlertTime,
        'scheduledTime': shiftEndTime,
      });
    }

    notifyListeners();
  }

  void clearIfNewDay() {
    final now = DateTime.now();
    if (lastGeneratedDate != null &&
        (now.year != lastGeneratedDate!.year ||
         now.month != lastGeneratedDate!.month ||
         now.day != lastGeneratedDate!.day)) {
      shiftAlerts.clear();
      lastGeneratedDate = DateTime(now.year, now.month, now.day);
    }
  }
}