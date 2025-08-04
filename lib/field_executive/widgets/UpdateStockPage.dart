import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants/colors.dart';

class UpdateStockPage extends StatefulWidget {
  const UpdateStockPage({super.key});

  @override
  State<UpdateStockPage> createState() => _UpdateStockPageState();
}

class _UpdateStockPageState extends State<UpdateStockPage> {
  final productIdController = TextEditingController();
  final newStockController = TextEditingController();

  String message = '';
  Color messageColor = Colors.green;

  Future<void> updateStock() async {
    final productId = productIdController.text.trim();
    final stockText = newStockController.text.trim();
    final newStock = int.tryParse(stockText);

    if (productId.isEmpty || newStock == null || newStock < 0) {
      setState(() {
        message = "❗ Please enter valid product ID and positive stock quantity.";
        messageColor = Colors.red;
      });
      return;
    }

    try {
      final response = await http.put(
        Uri.parse('https://yourapi.com/api/products/$productId/stock'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'stock': newStock}),
      );

      setState(() {
        if (response.statusCode == 200) {
          message = "✅ Stock updated successfully!";
          messageColor = Colors.green;
        } else {
          message = "❌ Failed to update stock. (${response.statusCode})";
          messageColor = Colors.red;
        }
      });
    } catch (e) {
      setState(() {
        message = "⚠️ Error: \${e.toString()}";
        messageColor = Colors.red;
      });
    }
  }

  @override
  void dispose() {
    productIdController.dispose();
    newStockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Update Stock"),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Enter Stock Update Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: productIdController,
                  decoration: InputDecoration(
                    labelText: "Product ID",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: AppColors.inputFill,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: newStockController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "New Stock Quantity",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: AppColors.inputFill,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: updateStock,
                  icon: const Icon(Icons.update),
                  label: const Text("Update Stock"),
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
                    style: TextStyle(color: messageColor, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
