import 'package:flutter/material.dart';
import '../controllers/performance_reports.dart';
import 'sales_manager_drawer.dart';
import '../../constants/colors.dart';

class SalesManagerPerformanceReportsScreen extends StatelessWidget {
  const SalesManagerPerformanceReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SalesManagerPerformanceReportsController();
    final reports = controller.reports;
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Performance Reports'),
        backgroundColor: AppColors.primaryBlue,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: const SalesManagerDrawer(),
      backgroundColor: AppColors.backgroundGray,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final report = reports[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              leading: const Icon(Icons.bar_chart, color: AppColors.secondaryBlue),
              title: Text(report['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(report['summary']),
              trailing: Text('${report['date'].day}/${report['date'].month}/${report['date'].year}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ),
          );
        },
      ),
    );
  }
} 