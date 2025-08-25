import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class PerformanceReportTile extends StatelessWidget {
  final Map<String, dynamic> report;
  const PerformanceReportTile({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: const Icon(Icons.bar_chart, color: AppColors.textPrimary),
        title: Text(report['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(report['summary']),
        trailing: Text('${report['date'].day}/${report['date'].month}/${report['date'].year}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ),
    );
  }
} 