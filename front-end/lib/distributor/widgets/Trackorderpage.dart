// track_order_page.dart
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../authpage/pages/auth_services.dart';
import 'package:role_based_app/constants/colors.dart';

class TrackOrderPage extends StatefulWidget {
  const TrackOrderPage({super.key});

  @override
  State<TrackOrderPage> createState() => _TrackOrderPageState();
}

class _TrackOrderPageState extends State<TrackOrderPage> {
  final dio = Dio(BaseOptions(baseUrl: "https://frontman-backend-2.onrender.com/"));

  bool loading = false;
  String? message;
  Map<String, dynamic>? orderDetails;
  final TextEditingController orderIdController = TextEditingController();

  Future<void> fetchOrderDetails(String orderId) async {
    setState(() {
      loading = true;
      message = null;
      orderDetails = null;
    });

    try {
      final authService = AuthService();
      final token = await authService.getToken();

      if (token == null) {
        setState(() => message = "⚠️ No token found. Please login again.");
        return;
      }

      final response = await dio.get(
        "/distributor/order/$orderId",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      setState(() {
        orderDetails = response.data as Map<String, dynamic>;
      });
    } catch (e) {
      setState(() {
        message = "❌ Error fetching order details: $e";
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Widget _buildOrderDetails() {
    if (orderDetails == null) return const SizedBox.shrink();

    final items = orderDetails!['items'] as List<dynamic>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("🆔 Order ID: ${orderDetails!['id']}",
            style: const TextStyle(fontWeight: FontWeight.bold)),
        Text("📌 Status: ${orderDetails!['status']}"),
        Text("📅 Date: ${orderDetails!['orderDate']}"),
        Text("💰 Subtotal: ₹${orderDetails!['subtotal']}"),
        Text("🎟️ Discount: ₹${orderDetails!['discountAmount']}"),
        Text("✅ Total: ₹${orderDetails!['total']}"),
        const SizedBox(height: 10),
        const Text("📦 Items:", style: TextStyle(fontWeight: FontWeight.bold)),
        ...items.map((item) => ListTile(
              leading: const Icon(Icons.shopping_bag_outlined),
              title: Text("${item['productName']} (x${item['quantity']})"),
              subtitle: Text("Unit Price: ₹${item['unitPrice']}"),
              trailing: Text("₹${item['total']}"),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Track Order"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: orderIdController,
              decoration: const InputDecoration(
                labelText: "Enter Order ID",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: loading
                  ? null
                  : () {
                      if (orderIdController.text.isNotEmpty) {
                        fetchOrderDetails(orderIdController.text.trim());
                      }
                    },
              icon: const Icon(Icons.search),
              label: loading
                  ? const Text("Tracking...")
                  : const Text("Track Order"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 20),
            if (message != null) Text(message!),
            Expanded(
              child: orderDetails == null
                  ? const Center(
                      child: Text(
                        "Enter an Order ID to track",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    )
                  : SingleChildScrollView(child: _buildOrderDetails()),
            ),
          ],
        ),
      ),
    );
  }
}
