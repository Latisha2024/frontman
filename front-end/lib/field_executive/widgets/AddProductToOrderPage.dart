import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../authpage/pages/auth_services.dart';

class AddProductToOrderPage extends StatefulWidget {
  const AddProductToOrderPage({super.key});

  @override
  State<AddProductToOrderPage> createState() => _AddProductToOrderPageState();
}

class _AddProductToOrderPageState extends State<AddProductToOrderPage> {
  final dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:5001"));

  final TextEditingController orderIdController = TextEditingController();
  final TextEditingController productIdController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  bool loading = false;
  String? message;
  Map<String, dynamic>? updatedOrder;

  Future<String?> _getToken() async {
    final authService = AuthService();
    return await authService.getToken();
  }

  Future<void> addProductToOrder() async {
    final orderId = orderIdController.text.trim();
    final productId = productIdController.text.trim();
    final quantityText = quantityController.text.trim();

    if (orderId.isEmpty || productId.isEmpty || quantityText.isEmpty) {
      setState(() => message = "⚠️ All fields are required");
      return;
    }

    final quantity = int.tryParse(quantityText);
    if (quantity == null || quantity <= 0) {
      setState(() => message = "⚠️ Quantity must be a positive integer");
      return;
    }

    setState(() {
      loading = true;
      message = null;
      updatedOrder = null;
    });

    try {
      final token = await _getToken();

      final response = await dio.put(
        "/fieldExecutive/orders/$orderId/add-product",
        data: {
          "productId": productId,
          "quantity": quantity,
        },
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      setState(() {
        updatedOrder = response.data['order'];
        message = response.data['message'];
        // Clear inputs
        productIdController.clear();
        quantityController.clear();
      });
    } catch (e) {
      String errorMessage = "❌ Failed to add product to order";
      if (e is DioError && e.response != null) {
        errorMessage = "❌ Error: ${e.response!.data['message'] ?? e.response!.statusMessage}";
      }
      setState(() => message = errorMessage);
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    orderIdController.dispose();
    productIdController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Product to Order")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (loading) const LinearProgressIndicator(),
            if (message != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  message!,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
              ),
            TextField(controller: orderIdController, decoration: const InputDecoration(labelText: "Order ID")),
            TextField(controller: productIdController, decoration: const InputDecoration(labelText: "Product ID")),
            TextField(controller: quantityController, decoration: const InputDecoration(labelText: "Quantity"), keyboardType: TextInputType.number),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: addProductToOrder, child: const Text("Add Product")),

            const SizedBox(height: 20),
            if (updatedOrder != null) ...[
              const Text("Updated Order", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Order ID: ${updatedOrder!['_id']}"),
              Text("Status: ${updatedOrder!['status']}"),
              Text("Order Items:", style: const TextStyle(fontWeight: FontWeight.bold)),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: updatedOrder!['orderItems'].length,
                itemBuilder: (context, index) {
                  final item = updatedOrder!['orderItems'][index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text("${item['product']['name']}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Quantity: ${item['quantity']}"),
                          Text("Unit Price: \$${item['unitPrice']}"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
