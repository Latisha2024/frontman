import 'package:flutter/material.dart';

class SalesManagerPerformanceReportsController extends ChangeNotifier {
  List<Map<String, dynamic>> reports = [
    {'id': '1', 'title': 'May Sales', 'summary': 'Total sales: 1200', 'date': DateTime.now()},
    {'id': '2', 'title': 'April Sales', 'summary': 'Total sales: 1100', 'date': DateTime.now().subtract(const Duration(days: 30))},
  ];
}