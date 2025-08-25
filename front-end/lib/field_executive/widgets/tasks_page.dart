import 'package:flutter/material.dart';
import '../../constants/colors.dart'; // Adjust path if needed

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = [
      {
        'title': 'Visit Client A',
        'description': 'Meet client A at 11:00 AM for product demo and feedback collection.',
        'status': 'Pending'
      },
      {
        'title': 'Collect Payment from Client B',
        'description': 'Collect payment for invoice #234 from Client B by 2:00 PM.',
        'status': 'In Progress'
      },
      {
        'title': 'Update Inventory',
        'description': 'Sync inventory data collected during the last visit with the warehouse server.',
        'status': 'Completed'
      },
      {
        'title': 'Deliver Order #4567',
        'description': 'Deliver product package to Client C before 5:00 PM.',
        'status': 'Pending'
      },
      {
        'title': 'Schedule Next Visit with Client D',
        'description': 'Call Client D and fix the appointment for next week.',
        'status': 'Pending'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Assigned Tasks",
          style: TextStyle(color: AppColors.textLight),
        ),
        backgroundColor: AppColors.primaryBlue,
        elevation: 2,
        iconTheme: const IconThemeData(color: AppColors.textLight),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: tasks.isEmpty
            ? Center(
                child: Text(
                  "No tasks assigned yet.",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  final String status = task['status'] ?? '';

                  Color statusColor;
                  switch (status) {
                    case 'Completed':
                      statusColor = AppColors.success;
                      break;
                    case 'In Progress':
                      statusColor = AppColors.warning;
                      break;
                    case 'Pending':
                    default:
                      statusColor = AppColors.error;
                      break;
                  }

                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.task_alt,
                                  color: AppColors.primaryBlue),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  task['title'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            task['description'] ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Chip(
                                label: Text(status),
                                backgroundColor: statusColor.withOpacity(0.15),
                                labelStyle: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text(task['title'] ?? 'Task'),
                                      content: Text(
                                          '${task['description']}\n\nStatus: $status'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx),
                                          child: const Text('Close'),
                                        )
                                      ],
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryBlue,
                                ),
                                child: const Text(
                                  "View Task",
                                  style: TextStyle(color: AppColors.textLight),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
