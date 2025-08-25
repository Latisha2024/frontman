import 'package:flutter/material.dart';
import '../controllers/approve_dvr_reports.dart';
import 'sales_manager_drawer.dart';
import '../../constants/colors.dart';

class SalesManagerApproveDvrReportsScreen extends StatefulWidget {
  const SalesManagerApproveDvrReportsScreen({super.key});

  @override
  State<SalesManagerApproveDvrReportsScreen> createState() => _SalesManagerApproveDvrReportsScreenState();
}

class _SalesManagerApproveDvrReportsScreenState extends State<SalesManagerApproveDvrReportsScreen> {
  final controller = SalesManagerApproveDvrReportsController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Approve DVR Reports'),
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
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final reports = controller.reports;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  leading: const Icon(Icons.description, color: AppColors.secondaryBlue),
                  title: Text('Executive: ${report['executiveName']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Details: ${report['details']}'),
                      Text('Submitted: ${report['submittedAt'].year}-${report['submittedAt'].month}-${report['submittedAt'].day}'),
                      Text('Status: ${report['status']}', style: TextStyle(color: report['status'] == 'Approved' ? Colors.green : report['status'] == 'Rejected' ? Colors.red : Colors.orange)),
                    ],
                  ),
                  trailing: report['status'] == 'Pending'
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check, color: Colors.green),
                              onPressed: () => controller.approveReport(index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () => controller.rejectReport(index),
                            ),
                          ],
                        )
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
} 