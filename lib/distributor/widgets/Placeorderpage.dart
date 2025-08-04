// place_order_page.dart
import 'package:flutter/material.dart';
import 'package:role_based_app/constants/colors.dart';

class PlaceOrderPage extends StatefulWidget {
  const PlaceOrderPage({super.key});

  @override
  State<PlaceOrderPage> createState() => _PlaceOrderPageState();
}

class _PlaceOrderPageState extends State<PlaceOrderPage> {
  final distributorIdController = TextEditingController();
  final productIdController = TextEditingController();
  final quantityController = TextEditingController();
  String message = '';

  void submitOrder() {
    final distributorId = distributorIdController.text;
    final productId = productIdController.text;
    final quantity = quantityController.text;
    if (distributorId.isEmpty || productId.isEmpty || quantity.isEmpty) {
      setState(() => message = 'All fields are required');
      return;
    }
    setState(() => message = 'Order placed for Product $productId, Qty $quantity by Distributor $distributorId');
  }

  Widget buildField(String label, TextEditingController controller, {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: type,
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
    productIdController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Place Order"),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildField("Distributor ID", distributorIdController, type: TextInputType.number),
            buildField("Product ID", productIdController),
            buildField("Quantity", quantityController, type: TextInputType.number),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: submitOrder,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text("Submit Order"),
            ),
            const SizedBox(height: 12),
            Text(message, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
