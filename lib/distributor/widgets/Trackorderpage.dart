// track_order_page.dart
import 'package:flutter/material.dart';
import 'package:role_based_app/constants/colors.dart';

class TrackOrderPage extends StatefulWidget {
  const TrackOrderPage({super.key});

  @override
  State<TrackOrderPage> createState() => _TrackOrderPageState();
}

class _TrackOrderPageState extends State<TrackOrderPage> {
  final orderIdController = TextEditingController();
  String statusMessage = '';

  void trackOrder() {
    final orderId = orderIdController.text.trim();
    if (orderId.isEmpty) {
      setState(() => statusMessage = 'Please enter a valid Order ID');
      return;
    }
    // Simulated status response
    setState(() => statusMessage = 'Order #$orderId is currently: In Transit');
  }

  @override
  void dispose() {
    orderIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Track Order Status"),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: orderIdController,
              decoration: const InputDecoration(
                labelText: "Order ID",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: trackOrder,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text("Track Order"),
            ),
            const SizedBox(height: 16),
            Text(statusMessage, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
