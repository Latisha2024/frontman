import 'package:flutter/material.dart';

class SalesManagerAssignTasksController extends ChangeNotifier {
  List<Map<String, dynamic>> tasks = [
    {'id': '1', 'executiveId': '1', 'description': 'Visit client A', 'dueDate': DateTime.now().add(const Duration(days: 1)), 'priority': 'High', 'status': 'Assigned'},
    {'id': '2', 'executiveId': '2', 'description': 'Collect report', 'dueDate': DateTime.now().add(const Duration(days: 2)), 'priority': 'Normal', 'status': 'Assigned'},
  ];

  void addTask({required String executiveId, required String description, required DateTime dueDate, required String priority}) {
    tasks.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'executiveId': executiveId,
      'description': description,
      'dueDate': dueDate,
      'priority': priority,
      'status': 'Assigned',
    });
    notifyListeners();
  }
} 