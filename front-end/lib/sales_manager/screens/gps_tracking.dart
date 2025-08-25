import 'package:flutter/material.dart';
import '../controllers/gps_tracking.dart';
import 'sales_manager_drawer.dart';
import '../../constants/colors.dart';

class SalesManagerGpsTrackingScreen extends StatelessWidget {
  const SalesManagerGpsTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SalesManagerGpsTrackingController();
    final executives = controller.executives;
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
      ),
      drawer: const SalesManagerDrawer(),
      backgroundColor: AppColors.backgroundGray,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: executives.length,
        itemBuilder: (context, index) {
          final exec = executives[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              leading: const Icon(Icons.person_pin_circle, color: AppColors.secondaryBlue),
              title: Text(exec['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(exec['location'] ?? 'No location'),
              trailing: Text(
                exec['lastUpdated'] != null ? 'Updated: ${exec['lastUpdated'].hour}:${exec['lastUpdated'].minute.toString().padLeft(2, '0')}' : '',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }
} 