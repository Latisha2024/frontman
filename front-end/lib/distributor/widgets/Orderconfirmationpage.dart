import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../../authpage/pages/auth_services.dart';

class OrderConfirmationPage extends StatefulWidget {
  const OrderConfirmationPage({super.key});

  @override
  State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  final TextEditingController orderIdController = TextEditingController();
  final dio = Dio(BaseOptions(baseUrl: "https://frontman-1.onrender.com"));

  bool loading = false;
  String? message;
  Map<String, dynamic>? confirmationData;

  final currencyFormatter = NumberFormat.currency(locale: "en_IN", symbol: "₹"); // INR formatting
  final dateFormatter = DateFormat("d MMM yyyy"); // Example: 15 Sep 2025

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

    // Format date
    String formattedDate = confirmationData!['orderDate'];
    try {
      final date = DateTime.parse(confirmationData!['orderDate']);
      formattedDate = dateFormatter.format(date);
    } catch (_) {}

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("✅ Your order has been confirmed!",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(
                  "Order #${confirmationData!['orderId']} was placed on $formattedDate "
                  "and is currently **${confirmationData!['status']}**.",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text("Estimated delivery: ${confirmationData!['estimatedDelivery']} 🚚"),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("🛍️ Items in your order:",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ...items.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        "- ${item['productName']} (x${item['quantity']}) "
                        "with ${item['warrantyPeriod']} months warranty "
                        "for ${currencyFormatter.format(item['total'])}",
                        style: const TextStyle(fontSize: 15),
                      ),
                    )),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        Card(
          color: Colors.blueGrey[50],
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("💳 Payment Summary",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text("Subtotal: ${currencyFormatter.format(pricing['subtotal'])}"),
                Text("Discount applied: -${currencyFormatter.format(pricing['discountAmount'])}"),
                if (promo != null) Text("Promo code used: ${promo['code']} 🎟️"),
                const Divider(),
                Text(
                  "Total amount paid: ${currencyFormatter.format(pricing['total'])}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
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
              decoration: InputDecoration(
                labelText: "Enter your Order ID",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.receipt_long),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: loading ? null : getOrderConfirmation,
              icon: const Icon(Icons.receipt),
              label: const Text("📄 Get Confirmation"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),

            if (loading) const CircularProgressIndicator(),
            if (message != null) Text(message!, style: const TextStyle(color: Colors.red, fontSize: 16)),
            if (confirmationData != null) _buildConfirmationDetails(),
          ],
        ),
      ),
    );
  }
}

