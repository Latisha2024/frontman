import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../url.dart';

class StockController {
  // BaseUrl.b_url already ends with a trailing slash; avoid double slashes in the final URL
  static const String baseUrl = '${BaseUrl.b_url}admin/stock';

  // GET /admin/stock - Get all stock entries
  static Future<List<Map<String, dynamic>>> getAllStock() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer ' + token,
        },
      );

      if (response.statusCode == 200) {
        final dynamic body = json.decode(response.body);
        final List<dynamic> data = body is List ? body : (body['data'] as List? ?? []);
        return data.cast<Map<String, dynamic>>();
      } else {
        try {
          final err = json.decode(response.body);
          final msg = err['message'] ?? err['error'] ?? response.reasonPhrase ?? 'Unknown error';
          throw Exception('Failed to fetch stock entries: $msg');
        } catch (_) {
          throw Exception('Failed to fetch stock entries: ${response.statusCode}');
        }
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
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final body = json.encode({
        'productId': productId.trim(),
        'status': status.trim(),
        'location': location.trim(),
      });

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer ' + token,
        },
        body: body,
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        try {
          final err = json.decode(response.body);
          final msg = err['message'] ?? err['error'] ?? response.reasonPhrase ?? 'Unknown error';
          throw Exception('Failed to create stock entry: $msg');
        } catch (_) {
          throw Exception('Failed to create stock entry: ${response.statusCode}');
        }
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
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final body = json.encode({
        'status': status.trim(),
        'location': location.trim(),
      });

      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer ' + token,
        },
        body: body,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        try {
          final err = json.decode(response.body);
          final msg = err['message'] ?? err['error'] ?? response.reasonPhrase ?? 'Unknown error';
          throw Exception('Failed to update stock entry: $msg');
        } catch (_) {
          throw Exception('Failed to update stock entry: ${response.statusCode}');
        }
      }
    } catch (e) {
      throw Exception('Error updating stock entry: $e');
    }
  }

  // DELETE /admin/stock/{id} - Delete a stock entry by ID
  static Future<Map<String, dynamic>> deleteStock({
    required String id,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer ' + token,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        if (response.body.isNotEmpty) {
          return json.decode(response.body);
        }
        return {'message': 'Stock deleted successfully'};
      } else {
        try {
          final err = json.decode(response.body);
          final msg = err['message'] ?? err['error'] ?? response.reasonPhrase ?? 'Unknown error';
          throw Exception('Failed to delete stock entry: $msg');
        } catch (_) {
          throw Exception('Failed to delete stock entry: ${response.statusCode}');
        }
      }
    } catch (e) {
      throw Exception('Error deleting stock entry: $e');
    }
  }

  // DELETE /admin/stock/cleanup-broken - Cleanup broken stock entries
  static Future<Map<String, dynamic>> cleanupBrokenStock() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final response = await http.delete(
        Uri.parse('$baseUrl/cleanup-broken'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer ' + token,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        try {
          final err = json.decode(response.body);
          final msg = err['message'] ?? err['error'] ?? response.reasonPhrase ?? 'Unknown error';
          throw Exception('Failed to cleanup broken stock: $msg');
        } catch (_) {
          throw Exception('Failed to cleanup broken stock: ${response.statusCode}');
        }
      }
    } catch (e) {
      throw Exception('Error cleaning up broken stock: $e');
    }
  }
}
