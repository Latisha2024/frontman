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
  bool isError = false;

  void submitOrder() {
    final distributorId = distributorIdController.text.trim();
    final productId = productIdController.text.trim();
    final quantity = quantityController.text.trim();

    if (distributorId.isEmpty || productId.isEmpty || quantity.isEmpty) {
      setState(() {
        message = '⚠️ All fields are required.';
        isError = true;
      });
      return;
    }

    setState(() {
      message = '✅ Order placed:\nProduct: $productId\nQuantity: $quantity\nDistributor: $distributorId';
      isError = false;
    });
  }

  Widget buildField(String label, TextEditingController controller,
      {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
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
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Place Order"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildField("Distributor ID", distributorIdController, type: TextInputType.number),
            buildField("Product ID", productIdController),
            buildField("Quantity", quantityController, type: TextInputType.number),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: submitOrder,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text("Submit Order"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (message.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isError ? Colors.red[100] : Colors.green[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 16,
                    color: isError ? Colors.red[900] : Colors.green[800],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
