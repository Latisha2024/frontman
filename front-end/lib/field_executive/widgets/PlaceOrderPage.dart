import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../authpage/pages/auth_services.dart';

class FieldExecutivePlaceOrderPage extends StatefulWidget {
  const FieldExecutivePlaceOrderPage({super.key});

  @override
  State<FieldExecutivePlaceOrderPage> createState() => _FieldExecutivePlaceOrderPageState();
}

class _FieldExecutivePlaceOrderPageState extends State<FieldExecutivePlaceOrderPage> {
  final TextEditingController productIdController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:5001")); // Update baseUrl if needed

  bool loading = false;
  String? message;

  Future<void> placeOrder() async {
    final productId = productIdController.text.trim();
    final quantity = int.tryParse(quantityController.text.trim()) ?? 0;

    if (productId.isEmpty || quantity <= 0) {
      setState(() => message = "⚠️ Please enter valid product ID and quantity");
      return;
    }

    setState(() {
      loading = true;
      message = null;
    });

    try {
      final authService = AuthService();
      final token = await authService.getToken();

      if (token == null) {
        setState(() => message = "⚠️ No token found. Please login again.");
        return;
      }

      final response = await dio.post(
        "/fieldExecutive/orders",
        data: {
          "items": [
            {
              "productId": productId,
              "quantity": quantity,
            }
          ]
        },
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      setState(() {
        message = "✅ Order placed successfully! Order ID: ${response.data['order']['id']}";
        productIdController.clear();
        quantityController.clear();
      });
    } catch (e) {
      setState(() => message = "❌ Error placing order: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Field Executive Place Order")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: productIdController,
              decoration: const InputDecoration(labelText: "Product ID"),
            ),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Quantity"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : placeOrder,
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Submit Order"),
            ),
            if (message != null) ...[
              const SizedBox(height: 20),
              Text(
                message!,
                style: TextStyle(
                  color: message!.contains("✅") ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

