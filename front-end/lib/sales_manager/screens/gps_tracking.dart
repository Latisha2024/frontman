import 'package:flutter/material.dart';
import '../../admin/screens/admin_drawer.dart';
import '../controllers/gps_tracking.dart';
import 'sales_manager_drawer.dart';
import '../../constants/colors.dart';

class SalesManagerGpsTrackingScreen extends StatefulWidget {
  final String role;
  const SalesManagerGpsTrackingScreen({super.key, required this.role});

  @override
  State<SalesManagerGpsTrackingScreen> createState() => _SalesManagerGpsTrackingScreenState();
}

class _SalesManagerGpsTrackingScreenState extends State<SalesManagerGpsTrackingScreen> {
  late final SalesManagerGpsTrackingController controller;

  @override
  void initState() {
    super.initState();
    controller = SalesManagerGpsTrackingController();
    // Fetch locations on load
    controller.fetchLocations();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Field Executive GPS'),
        backgroundColor: AppColors.primaryBlue,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.fetchLocations,
            tooltip: 'Refresh',
          )
        ],
      ),
      drawer: widget.role == "admin" ? const AdminDrawer() : const SalesManagerDrawer(),
      backgroundColor: AppColors.backgroundGray,
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      'Error: ${controller.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            );
          }

          final executives = controller.executives;
          if (executives.isEmpty) {
            return const Center(
              child: Text('No active locations found'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: executives.length,
            itemBuilder: (context, index) {
              final exec = executives[index];
              final DateTime? ts = exec['lastUpdated'] is DateTime ? exec['lastUpdated'] as DateTime : null;
              final timeLabel = ts != null
                  ? 'Updated: ${ts.hour}:${ts.minute.toString().padLeft(2, '0')}'
                  : '';
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  leading: const Icon(Icons.person_pin_circle, color: AppColors.secondaryBlue),
                  title: Text(exec['name'] ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(exec['location'] ?? 'No location'),
                  trailing: Text(
                    timeLabel,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}