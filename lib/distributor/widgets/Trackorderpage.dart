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
  bool isError = false;

  void trackOrder() {
    final orderId = orderIdController.text.trim();

    if (orderId.isEmpty) {
      setState(() {
        statusMessage = '⚠️ Please enter a valid Order ID';
        isError = true;
      });
      return;
    }

    // Simulated status response
    setState(() {
      statusMessage = '📦 Order #$orderId is currently: In Transit';
      isError = false;
    });
  }

  @override
  void dispose() {
    orderIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Track Order Status"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: orderIdController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Order ID",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: trackOrder,
                icon: const Icon(Icons.search),
                label: const Text("Track Order"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (statusMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isError ? Colors.red[100] : Colors.blue[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusMessage,
                  style: TextStyle(
                    fontSize: 16,
                    color: isError ? Colors.red[900] : Colors.blue[900],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
