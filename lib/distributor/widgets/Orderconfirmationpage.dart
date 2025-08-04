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

  void getConfirmation() {
    final orderId = orderIdController.text.trim();
    if (orderId.isEmpty) {
      setState(() => confirmationDetails = 'Please enter a valid Order ID');
      return;
    }
    // Mock confirmation detail
    setState(() => confirmationDetails =
        'Order #$orderId has been successfully confirmed and will be delivered soon.');
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
        title: const Text("Order Confirmation"),
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
              onPressed: getConfirmation,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text("Get Confirmation"),
            ),
            const SizedBox(height: 16),
            Text(confirmationDetails, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
