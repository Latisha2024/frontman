// create_order_page.dart
import 'package:flutter/material.dart';
import 'package:role_based_app/constants/colors.dart';

class CreateOrderPage extends StatefulWidget {
  const CreateOrderPage({super.key});

  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  final distributorIdController = TextEditingController();
  final productListController = TextEditingController();
  String message = '';

  void createOrder() {
    final distributorId = distributorIdController.text.trim();
    final productList = productListController.text.trim();

    if (distributorId.isEmpty || productList.isEmpty) {
      setState(() => message = 'All fields are required');
      return;
    }

    setState(() => message = 'Order created for Distributor $distributorId with products: $productList');
  }

  Widget buildField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    distributorIdController.dispose();
    productListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Order"),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildField("Distributor ID", distributorIdController),
            buildField("Product List (JSON)", productListController, maxLines: 4),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: createOrder,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text("Create Order"),
            ),
            const SizedBox(height: 12),
            Text(message, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
