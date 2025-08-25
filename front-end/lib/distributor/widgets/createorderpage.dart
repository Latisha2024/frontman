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
      setState(() => message = '⚠️ All fields are required');
      return;
    }

    // Here you can implement JSON validation or backend API call
    setState(() {
      message = '✅ Order created for Distributor: $distributorId\n\n🧾 Products:\n$productList';
    });
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: maxLines > 1 ? TextInputType.multiline : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Create Order"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildTextField(label: "Distributor ID", controller: distributorIdController),
            buildTextField(label: "Product List (as JSON)", controller: productListController, maxLines: 5),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: createOrder,
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
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  message,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
