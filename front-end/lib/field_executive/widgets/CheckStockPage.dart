// stock_page.dart
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../authpage/pages/auth_services.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  final dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:5001"));

  bool loading = false;
  String? message;
  List<dynamic> stockList = []; // To store the fetched stock items

  Future<String?> _getToken() async {
    final authService = AuthService();
    return await authService.getToken();
  }

  Future<void> _getAssignedStock() async {
    setState(() {
      loading = true;
      message = null;
      stockList = [];
    });

    try {
      final token = await _getToken();
      if (token == null) {
        setState(() {
          message = "⚠️ Please login again.";
          loading = false;
        });
        return;
      }

      final response = await dio.get(
        "/fieldExecutive/stock",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      setState(() {
        stockList = response.data;
        message = "📦 ${stockList.length} stock items found.";
      });
    } catch (e) {
      String errorMessage = "❌ Error fetching stock.";
      if (e is DioError && e.response != null) {
        errorMessage = "❌ Error: ${e.response!.data['message'] ?? e.response!.statusMessage}";
      }
      setState(() => message = errorMessage);
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _getAssignedStock(); // Fetch stock on page load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(" Stock")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (loading) const LinearProgressIndicator(),
            if (message != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  message!,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
              ),
            const Divider(),
            const Text(
              "Current Stock Items",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (stockList.isEmpty && !loading)
              const Text("No stock items found."),
            ...stockList.map((stock) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(stock['product']?['name'] ?? 'No Product Name'),
                  subtitle: Text(
                    "ID: ${stock['id']}\n"
                    "Status: ${stock['status']}\n"
                    "Location: ${stock['location']}\n"
                    "Price: \$${stock['product']?['price'] ?? 'N/A'}",
                  ),
                  isThreeLine: true,
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
