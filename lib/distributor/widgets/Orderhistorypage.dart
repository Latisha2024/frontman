// order_history_page.dart
import 'package:flutter/material.dart';
import 'package:role_based_app/constants/colors.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  final distributorIdController = TextEditingController();
  List<String> orderHistory = [];

  void fetchOrderHistory() {
    final distributorId = distributorIdController.text.trim();
    if (distributorId.isEmpty) {
      setState(() => orderHistory = ['Please enter a distributor ID']);
      return;
    }

    // Mock data
    setState(() => orderHistory = [
      'Order ID: 001 - Delivered',
      'Order ID: 002 - In Transit',
      'Order ID: 003 - Cancelled',
    ]);
  }

  @override
  void dispose() {
    distributorIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order History"),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: distributorIdController,
              decoration: const InputDecoration(
                labelText: "Distributor ID",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: fetchOrderHistory,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text("Fetch History"),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: orderHistory.length,
                itemBuilder: (context, index) => ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(orderHistory[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
