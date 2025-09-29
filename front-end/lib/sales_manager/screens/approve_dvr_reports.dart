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
  void initState() {
    super.initState();
    // auto-load when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _onRefresh();
    });
  }

  Future<void> _onRefresh() async {
    try {
      await controller.loadAllReports();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Loaded ${controller.reports.length} report(s)')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load DVRs: $e')),
        );
      }
    }
  }

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
        actions: [
          IconButton(
            onPressed: _onRefresh,
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Refresh Reports',
          ),
        ],
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
                  title: Text(
                    'Executive: ${((report['executiveName'] as String?)?.trim().isNotEmpty ?? false)
                            ? (report['executiveName'] as String)
                            : (report['executiveId'] as String)}',
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Location: ${report['location']}'),
                      Text('Feedback: ${report['feedback']}'),
                      Text('Status: ${report['status']}', style: TextStyle(color: report['status'] == 'Approved' ? Colors.green : report['status'] == 'Rejected' ? Colors.red : Colors.orange)),
                    ],
                  ),
                  trailing: report['status'] == 'Pending'
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check, color: Colors.green),
                              onPressed: () async {
                                try {
                                  await controller.approveReportRemote(report['id']);
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('DVR approved')),
                                    );
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Failed to approve: $e')),
                                    );
                                  }
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () async {
                                try {
                                  await controller.rejectReportRemote(report['id']);
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('DVR rejected')),
                                    );
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Failed to reject: $e')),
                                    );
                                  }
                                }
                              },
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