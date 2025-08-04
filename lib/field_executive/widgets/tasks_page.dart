import 'package:flutter/material.dart';
import '../../constants/colors.dart'; // Adjust path as necessary

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = [
      {
        'title': 'Visit Client A',
        'description': 'Meet client A for product demo at 11:00 AM.',
        'status': 'Pending'
      },
      {
        'title': 'Collect Payment from Client B',
        'description': 'Collect payment invoice #234 from client B.',
        'status': 'In Progress'
      },
      {
        'title': 'Update Inventory',
        'description': 'Sync inventory data from last visit.',
        'status': 'Completed'
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
        child: ListView.builder(
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task['title'] ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      task['description'] ?? '',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(
                          label: Text(status),
                          backgroundColor: statusColor.withOpacity(0.2),
                          labelStyle: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // TODO: Handle task action
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
