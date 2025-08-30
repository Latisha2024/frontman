import 'package:flutter/material.dart';
import '../controllers/shift_alerts.dart';
import 'worker_drawer.dart';
import '../../constants/colors.dart';
import 'dart:async';

class WorkerShiftAlertsScreen extends StatefulWidget {
  const WorkerShiftAlertsScreen({super.key});

  @override
  State<WorkerShiftAlertsScreen> createState() => _WorkerShiftAlertsScreenState();
}

class _WorkerShiftAlertsScreenState extends State<WorkerShiftAlertsScreen> {
  final controller = WorkerShiftAlertsController();
  Timer? updateTimer;

  @override
  void initState() {
    super.initState();
    controller.generateDailySchedule();
    updateTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      controller.generateDailySchedule();
    });
  }

  @override
  void dispose() {
    updateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shift Alerts'),
        backgroundColor: AppColors.primary,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: const WorkerDrawer(),
      backgroundColor: AppColors.backgroundGray,
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          if (controller.shiftAlerts.isEmpty) {
            return const Center(
              child: Text('No alerts', style: TextStyle(color: Colors.white70, fontSize: 18)),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.shiftAlerts.length,
            itemBuilder: (context, index) {
              final alert = controller.shiftAlerts[index];
              return buildAlertCard(alert);
            },
          );
        },
      ),
    );
  }

  Widget buildAlertCard(Map<String, dynamic> alert) {
    final timestamp = alert['timestamp'] as DateTime;
    final type = alert['type'] as String;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            getAlertIcon(type),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getAlertTitle(type),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  Text(
                    alert['message'],
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  Text(
                    formatTimestamp(timestamp),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getAlertIcon(String type) {
    IconData iconData;
    Color iconColor;
    switch (type) {
      case 'shiftStart':
        iconData = Icons.play_circle_filled;
        iconColor = AppColors.secondaryBlue;
        break;
      case 'breakTime':
        iconData = Icons.coffee;
        iconColor = AppColors.secondaryBlue;
        break;
      case 'lunchBreak':
        iconData = Icons.restaurant;
        iconColor = AppColors.secondaryBlue;
        break;
      case 'secondBreak':
        iconData = Icons.coffee;
        iconColor = AppColors.secondaryBlue;
        break;
      case 'shiftEnd':
        iconData = Icons.stop_circle;
        iconColor = AppColors.secondaryBlue;
        break;
      default:
        iconData = Icons.notifications;
        iconColor = AppColors.secondaryBlue;
    }
    return Icon(iconData, color: iconColor, size: 32);
  }

  String getAlertTitle(String type) {
    switch (type) {
      case 'shiftStart':
        return 'Shift Start';
      case 'breakTime':
        return 'First Break';
      case 'lunchBreak':
        return 'Lunch Break';
      case 'secondBreak':
        return 'Second Break';
      case 'shiftEnd':
        return 'Shift End';
      default:
        return 'Alert';
    }
  }

  String formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else{
      return '${difference.inHours} hours ago';
    }
  }
}