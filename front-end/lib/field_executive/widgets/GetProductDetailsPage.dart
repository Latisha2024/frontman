import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../authpage/pages/auth_services.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  final dio = Dio(BaseOptions(baseUrl: "https://frontman-1.onrender.com"));
  bool loading = true;
  String? message;
  List orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
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

      final response = await dio.get(
        "/fieldExecutive/orders",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      setState(() {
        orders = response.data;
      });
    } catch (e) {
      setState(() {
        message = "❌ Error: $e";
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Orders")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : message != null
              ? Center(child: Text(message!))
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ExpansionTile(
                        title: Text(
                          "Order ID: ${order['id']} | Total: \$${order['totalAmount']}",
                        ),
                        subtitle: Text(
                            "Status: ${order['status']} | Date: ${order['orderDate'].split('T')[0]}"),
                        children: order['items']
                            .map<Widget>((item) => ListTile(
                                  title: Text(item['productName']),
                                  subtitle: Text(
                                      "Quantity: ${item['quantity']} | Unit Price: \$${item['unitPrice']}"),
                                ))
                            .toList(),
                      ),
                    );
                  },
                ),
    );
  }
}
