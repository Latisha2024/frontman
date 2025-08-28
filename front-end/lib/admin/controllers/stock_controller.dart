import 'dart:convert';
import 'package:http/http.dart' as http;

class StockController {
  static const String baseUrl = 'http://10.0.2.2:5000/admin/stock';


  // GET /admin/stock - Get all stock entries
  static Future<List<Map<String, dynamic>>> getAllStock() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to fetch stock entries: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching stock entries: $e');
    }
  }

  // POST /admin/stock - Create new stock entry
  static Future<Map<String, dynamic>> createStock({
    required String productId,
    required String status,
    required String location,
  }) async {
    try {
      final body = json.encode({
        'productId': productId,
        'status': status,
        'location': location,
      });

      final response = await http.post(
        Uri.parse(baseUrl),
        body: body,
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create stock entry: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating stock entry: $e');
    }
  }

  // PUT /admin/stock/{id} - Update stock entry
  static Future<Map<String, dynamic>> updateStock({
    required String id,
    required String status,
    required String location,
  }) async {
    try {
      final body = json.encode({
        'status': status,
        'location': location,
      });

      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        body: body,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to update stock entry: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating stock entry: $e');
    }
  }

  // DELETE /admin/stock/cleanup-broken - Cleanup broken stock entries
  static Future<Map<String, dynamic>> cleanupBrokenStock() async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/cleanup-broken'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to cleanup broken stock: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error cleaning up broken stock: $e');
    }
  }
}
