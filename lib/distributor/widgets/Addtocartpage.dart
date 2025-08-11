// add_to_cart_page.dart
import 'package:flutter/material.dart';
import 'package:role_based_app/constants/colors.dart';

class AddToCartPage extends StatefulWidget {
  const AddToCartPage({super.key});

  @override
  State<AddToCartPage> createState() => _AddToCartPageState();
}

class _AddToCartPageState extends State<AddToCartPage> {
  final productIdController = TextEditingController(text: 'PROD123'); // Demo data
  final quantityController = TextEditingController(text: '2'); // Demo data
  String message = '';

  void addToCart() {
    final productId = productIdController.text.trim();
    final quantity = quantityController.text.trim();

    if (productId.isEmpty || quantity.isEmpty) {
      setState(() => message = '❗ Please fill in both Product ID and Quantity.');
      return;
    }

    final qty = int.tryParse(quantity);
    if (qty == null || qty <= 0) {
      setState(() => message = '⚠️ Enter a valid positive quantity.');
      return;
    }

    setState(() => message = '✅ Product "$productId" with quantity $quantity added to cart!');
  }

  Widget buildTextField(String label, String hint, TextEditingController controller, TextInputType inputType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: AppColors.inputFill,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Add to Cart"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  "Fill product details to add item to cart",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                buildTextField("Product ID", "e.g. PROD123", productIdController, TextInputType.text),
                buildTextField("Quantity", "e.g. 2", quantityController, TextInputType.number),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: addToCart,
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text("Add to Cart"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 20),
                if (message.isNotEmpty)
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: message.contains('✅')
                          ? Colors.green
                          : message.contains('⚠️')
                              ? Colors.orange
                              : Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
