import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../authpage/pages/auth_services.dart';

class WorkerProductionController {
  final productIdController = TextEditingController();
  final quantityController = TextEditingController();
  final locationController = TextEditingController();
  String status = 'Available';

  late Dio dio;

  WorkerProductionController() {
    dio = Dio(BaseOptions(
      baseUrl: "https://frontman-1.onrender.com/",
    ));
  }

  Future<void> logProduction(BuildContext context) async {
    try {
      final token = await AuthService().getToken();
      if (token == null || token.isEmpty) {
        throw Exception("No token found");
      }
      dio.options.headers['Authorization'] = 'Bearer $token';

      final String productId = productIdController.text.trim();
      final String quantityStr = quantityController.text.trim();
      final String location = locationController.text.trim();

      if (productId.isEmpty || quantityStr.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product ID and Quantity are required")),
        );
        return;
      }

      final int quantity = int.tryParse(quantityStr) ?? 0;
      if (quantity <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Quantity must be a positive number")),
        );
        return;
      }

      final response = await dio.post(
        "/worker/production",
        data: {
          "productId": productId,
          "quantity": quantity,
          "location": location,
          "status": status,
        },
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(response.data['message'] ??
                  "Production logged successfully")),
        );
      }
    } on DioException catch (e) {
      final errorMsg =
          e.response?.data['message'] ?? "Failed to log production";
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMsg)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unexpected error occurred")),
      );
    }
  }

  void dispose() {
    productIdController.dispose();
    quantityController.dispose();
    locationController.dispose();
  }
}
