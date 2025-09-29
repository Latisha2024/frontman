import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/shift_alerts.dart';
import '../../constants/colors.dart';

class WorkerShiftAlertsScreen extends StatelessWidget {
  const WorkerShiftAlertsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WorkerShiftAlertsController(),
      child: Consumer<WorkerShiftAlertsController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Shift Alerts'),
              backgroundColor: AppColors.primary,
            ),
            backgroundColor: AppColors.backgroundGray,
            body: Column(
              children: [
                // 🔹 Show progress bar when refreshing
                if (controller.loading)
                  const LinearProgressIndicator(
                    minHeight: 3,
                    backgroundColor: Colors.transparent,
                  ),

                // 🔹 Content area
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await controller.fetchAlerts();
                    },
                    child: controller.shiftAlerts.isEmpty
                        ? ListView(
                            // RefreshIndicator requires scrollable child
                            children: const [
                              SizedBox(height: 200),
                              Center(
                                child: Text(
                                  'No alerts',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 18),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: controller.shiftAlerts.length,
                            itemBuilder: (context, index) {
                              final alert = controller.shiftAlerts[index];
                              return buildAlertCard(alert, controller);
                            },
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildAlertCard(
      ShiftAlert alert, WorkerShiftAlertsController controller) {
    IconData iconData;
    Color iconColor;

    if (alert.acknowledged) {
      iconData = Icons.check_circle;
      iconColor = Colors.green;
    } else {
      iconData = Icons.notifications;
      iconColor = AppColors.secondaryBlue;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: alert.acknowledged ? Colors.grey[300] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(iconData, color: iconColor, size: 32),
        title: Text(
          alert.message,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: alert.acknowledged ? Colors.grey : Colors.black87,
          ),
        ),
        subtitle: Text(
          formatTimestamp(alert.createdAt),
          style: TextStyle(color: Colors.grey.shade600),
        ),
        trailing: alert.acknowledged
            ? null
            : TextButton(
                onPressed: () => controller.acknowledgeAlert(alert.id),
                child: const Text('Acknowledge'),
              ),
      ),
    );
  }

  String formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final mins = difference.inMinutes;
      return '$mins minute${mins > 1 ? 's' : ''} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours hour${hours > 1 ? 's' : ''} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      final days = difference.inDays;
      return '$days days ago';
    }
  }
}
