import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../authpage/pages/auth_services.dart';
import 'package:role_based_app/distributor/screens/distributorsUI.dart';

class PlaceOrderPage extends StatefulWidget {
  const PlaceOrderPage({super.key});

  @override
  State<PlaceOrderPage> createState() => _PlaceOrderPageState();
}

class _PlaceOrderPageState extends State<PlaceOrderPage> {
  final TextEditingController productIdController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final dio = Dio(BaseOptions(baseUrl: "https://frontman-1.onrender.com"));

  bool loading = false;
  String? message;

  Future<String?> _getToken() async {
    final authService = AuthService();
    return await authService.getToken();
  }

  Future<void> placeOrder() async {
    setState(() {
      loading = true;
      message = null;
    });

    try {
      final token = await _getToken();
      if (token == null) {
        setState(() => message = "⚠️ No token found. Please login again.");
        return;
      }

      final response = await dio.post(
        "/distributor/order",
        data: {
          "items": [
            {
              "productId": productIdController.text,
              "quantity": int.tryParse(quantityController.text) ?? 0,
            }
          ]
        },
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      final data = response.data;

      if (data != null && data["order"] != null) {
        final order = data["order"];
        final items = order["orderItems"] as List<dynamic>;

        String itemsText = items.map((item) {
          return "📦 ${item["quantity"]} × Product ID: ${item["productId"]} @ ₹${item["unitPrice"]}";
        }).join("\n");

        setState(() {
          message = """
✅ Order placed successfully! 🎉

🆔 Order ID: ${order["id"]}
📅 Date: ${order["orderDate"]}
📌 Status: ${order["status"]}

$itemsText
""";
        });
      } else {
        setState(() => message = "⚠️ Unexpected response format from server.");
      }
    } catch (e) {
      setState(() => message = "❌ Error: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Place Order",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: const Icon(Icons.shopping_cart, size: 26),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, size: 26),
            tooltip: "Back to Dashboard",
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const DistributorHomePage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: productIdController,
                      decoration: const InputDecoration(
                        labelText: "Product ID",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Quantity",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: loading ? null : placeOrder,
                      icon: loading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Icon(Icons.send),
                      label: Text(loading ? "Placing..." : "Submit Order"),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            if (message != null)
              Card(
                color: message!.startsWith("✅") ? Colors.green[50] : Colors.red[50],
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    message!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: message!.startsWith("✅") ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}




