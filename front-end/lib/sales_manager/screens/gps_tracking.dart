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
  final TextEditingController userIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = SalesManagerGpsTrackingController();
    // Do not auto-fetch without userId; let user input a userId and tap search
    userIdController.addListener(() {
      // Rebuild to enable/disable actions based on input
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    userIdController.dispose();
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
            onPressed: userIdController.text.trim().isEmpty
                ? null
                : () => controller.fetchLocationsByName(userIdController.text.trim()),
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

          final locations = controller.locations;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Search bar
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: userIdController,
                      decoration: const InputDecoration(
                        labelText: 'User Name',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: userIdController.text.trim().isEmpty
                        ? null
                        : () => controller.fetchLocationsByName(userIdController.text.trim()),
                    icon: const Icon(Icons.search),
                    label: const Text('Search'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.buttonPrimary, foregroundColor: Colors.white),
                  )
                ],
              ),
              const SizedBox(height: 16),
              if (userIdController.text.trim().isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text('Enter a User Name to view location history', textAlign: TextAlign.center),
                ),
              if (locations.isEmpty)
                const Center(child: Text('No location history'))
              else
                ...locations.map((loc) {
                  final DateTime? ts = loc['timeStamp'] as DateTime?;
                  final timeLabel = ts != null ? '${ts.toLocal()}' : '';
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.place, color: AppColors.secondaryBlue),
                      title: Text(loc['label'] ?? 'Location', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('User: ${loc['userId']}\nTime: $timeLabel'),
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}