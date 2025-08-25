import 'package:flutter/material.dart';

class SalesManagerApproveDvrReportsController extends ChangeNotifier {
  List<Map<String, dynamic>> reports = [
    {'id': '1', 'executiveId': '1', 'executiveName': 'Abi', 'details': 'Visited 3 clients', 'submittedAt': DateTime.now(), 'status': 'Pending'},
    {'id': '2', 'executiveId': '2', 'executiveName': 'Rahul', 'details': 'Delivered products', 'submittedAt': DateTime.now(), 'status': 'Pending'},
  ];

  void approveReport(int index) {
    reports[index]['status'] = 'Approved';
    notifyListeners();
  }

  void rejectReport(int index) {
    reports[index]['status'] = 'Rejected';
    notifyListeners();
  }
} 