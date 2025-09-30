import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../authpage/pages/auth_services.dart';

class WorkerManageStockController {
  final stockIdController = TextEditingController();
  final locationController = TextEditingController();
  String selectedStatus = "Available"; // default dropdown value

  late Dio dio;

  WorkerManageStockController() {
    dio = Dio(BaseOptions(
      baseUrl: "http://localhost:5000", // Android emulator
      // Use http://localhost:5000 for web
      // Or machine IP for physical device
    ));
  }

  Future<void> updateStock(BuildContext context) async {
    try {
      final token = await AuthService().getToken();

      if (token == null || token.isEmpty) {
        throw Exception("No token found");
      }

      dio.options.headers['Authorization'] = 'Bearer $token';

      final String stockId = stockIdController.text.trim();
      final String location = locationController.text.trim();

      if (stockId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Stock ID is required")),
        );
        return;
      }

      if (location.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location is required")),
        );
        return;
      }

      final response = await dio.put(
        "/worker/stock/$stockId",
        data: {
          "status": selectedStatus,
          "location": location,
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(response.data['message'] ?? "Stock updated successfully"),
          ),
        );
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data['message'] ?? "Failed to update stock";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unexpected error occurred")),
      );
    }
  }

  void dispose() {
    stockIdController.dispose();
    locationController.dispose();
  }
}
