// order_confirmation_page.dart
import 'package:flutter/material.dart';
import 'package:role_based_app/constants/colors.dart';

class OrderConfirmationPage extends StatefulWidget {
  const OrderConfirmationPage({super.key});

  @override
  State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  final orderIdController = TextEditingController();
  String confirmationDetails = '';
  bool isError = false;

  void getConfirmation() {
    final orderId = orderIdController.text.trim();
    if (orderId.isEmpty) {
      setState(() {
        confirmationDetails = '⚠️ Please enter a valid Order ID';
        isError = true;
      });
      return;
    }

    setState(() {
      confirmationDetails =
          '✅ Order #$orderId has been successfully confirmed and will be delivered soon.';
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
        title: const Text("Order Confirmation"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: orderIdController,
              decoration: const InputDecoration(
                labelText: "Order ID",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: getConfirmation,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text("Get Confirmation"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (confirmationDetails.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isError ? Colors.red.shade100 : Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      isError ? Icons.error_outline : Icons.check_circle_outline,
                      color: isError ? Colors.red : Colors.green,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        confirmationDetails,
                        style: TextStyle(
                          fontSize: 16,
                          color: isError ? Colors.red[900] : Colors.green[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
