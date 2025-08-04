// add_to_cart_page.dart
import 'package:flutter/material.dart';
import 'package:role_based_app/constants/colors.dart';

class AddToCartPage extends StatefulWidget {
  const AddToCartPage({super.key});

  @override
  State<AddToCartPage> createState() => _AddToCartPageState();
}

class _AddToCartPageState extends State<AddToCartPage> {
  final productIdController = TextEditingController();
  final quantityController = TextEditingController();
  String message = '';

  void addToCart() {
    final productId = productIdController.text;
    final quantity = quantityController.text;
    if (productId.isEmpty || quantity.isEmpty) {
      setState(() => message = 'Please enter all fields');
      return;
    }
    setState(() => message = 'Product $productId with qty $quantity added to cart');
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: label.contains("Qty") ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    productIdController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add to Cart"),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildTextField("Product ID", productIdController),
            buildTextField("Quantity", quantityController),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: addToCart,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text("Add to Cart"),
            ),
            const SizedBox(height: 12),
            Text(message, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
