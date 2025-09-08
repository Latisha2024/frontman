// order_confirmation_page.dart
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../authpage/pages/auth_services.dart';

class OrderConfirmationPage extends StatefulWidget {
  const OrderConfirmationPage({super.key});

  @override
  State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  final TextEditingController orderIdController = TextEditingController();
  final dio = Dio(BaseOptions(baseUrl: "https://frontman-backend-2.onrender.com/"));

  bool loading = false;
  String? message;
  Map<String, dynamic>? confirmationData;

  Future<String?> _getToken() async {
    final authService = AuthService();
    return await authService.getToken();
  }

  Future<void> getOrderConfirmation() async {
    setState(() {
      loading = true;
      message = null;
      confirmationData = null;
    });
    try {
      final token = await _getToken();
      if (token == null) {
        setState(() => message = "⚠️ Please login again.");
        return;
      }

      final response = await dio.get(
        "/distributor/order/${orderIdController.text}/confirmation",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      setState(() {
        confirmationData = response.data;
      });
    } catch (e) {
      setState(() => message = "❌ Error: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  Widget _buildConfirmationDetails() {
    if (confirmationData == null) return const SizedBox();

    final items = (confirmationData!['items'] as List<dynamic>? ?? []);
    final pricing = confirmationData!['pricing'] ?? {};
    final promo = confirmationData!['promoCode'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("🧾 Order ID: ${confirmationData!['orderId']}"),
        Text("📅 Date: ${confirmationData!['orderDate']}"),
        Text("📦 Status: ${confirmationData!['status']}"),
        const Divider(),

        Text("🛒 Items:", style: const TextStyle(fontWeight: FontWeight.bold)),
        ...items.map((item) => ListTile(
              title: Text(item['productName']),
              subtitle: Text("Qty: ${item['quantity']}  |  Warranty: ${item['warrantyPeriod']} months"),
              trailing: Text("\$${item['total']}"),
            )),

        const Divider(),
        Text("💰 Subtotal: \$${pricing['subtotal']}"),
        Text("🎟️ Discount: -\$${pricing['discountAmount']}"),
        Text("✅ Total: \$${pricing['total']}"),
        if (promo != null) Text("Promo Applied: ${promo['code']}"),

        const Divider(),
        Text("🚚 Estimated Delivery: ${confirmationData!['estimatedDelivery']}"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order Confirmation")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: orderIdController,
              decoration: const InputDecoration(labelText: "Order ID"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: loading ? null : getOrderConfirmation,
              child: const Text("📄 Get Confirmation"),
            ),
            const SizedBox(height: 20),

            if (loading) const CircularProgressIndicator(),
            if (message != null) Text(message!, style: const TextStyle(color: Colors.red)),
            if (confirmationData != null) _buildConfirmationDetails(),
          ],
        ),
      ),
    );
  }
}
