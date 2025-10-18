/// update_stock.dart
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../authpage/pages/auth_services.dart';

class UpdateStockPage extends StatefulWidget {
  const UpdateStockPage({super.key});

  @override
  State<UpdateStockPage> createState() => _UpdateStockPageState();
}

class _UpdateStockPageState extends State<UpdateStockPage> {
  final TextEditingController stockItemIdController = TextEditingController();
  final TextEditingController updateStatusController = TextEditingController();

  final dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:5001"));

  bool loading = false;
  String? message;

  Future<String?> _getToken() async {
    final authService = AuthService();
    return await authService.getToken();
  }

  Future<void> _updateStockStatus() async {
    setState(() {
      loading = true;
      message = null;
    });

    try {
      final token = await _getToken();
      if (token == null) {
        setState(() {
          message = "⚠️ Please login again.";
          return;
        });
      }

      final response = await dio.put(
        "/fieldExecutive/stock/${stockItemIdController.text}",
        data: {
          "status": updateStatusController.text,
        },
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      setState(() {
        message = "🔄 Stock status updated successfully!";
        stockItemIdController.clear();
        updateStatusController.clear();
      });
    } catch (e) {
      String errorMessage = "❌ Error updating status. Please check the Item ID and status.";
      if (e is DioError && e.response != null) {
        errorMessage = "❌ Error: ${e.response!.data['message'] ?? e.response!.statusMessage}";
      }
      setState(() => message = errorMessage);
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Stock Status")),
      body: Padding(
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
            const SizedBox(height: 10),
            TextField(
              controller: stockItemIdController,
              decoration: const InputDecoration(labelText: "Enter Stock Item ID"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: updateStatusController,
              decoration: const InputDecoration(labelText: "New Status (e.g., 'Sold', 'Dispatched')"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : _updateStockStatus,
              child: const Text("🔄 Update Status"),
            ),
          ],
        ),
      ),
    );
  }
}
