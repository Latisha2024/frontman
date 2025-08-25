import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalesManagerGpsTrackingController extends ChangeNotifier {
  // Backend base URL (align with other controllers)
  // Android Emulator: http://10.0.2.2:5000
  // iOS Simulator/Web: http://localhost:5000
  // Physical device: http://<your-PC-LAN-IP>:5000
  static const String baseUrl = 'http://10.0.2.2:5000';

  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 8),
    receiveTimeout: const Duration(seconds: 8),
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  List<Map<String, dynamic>> executives = [];
  bool isLoading = false;
  String? error;

  Future<void> _attachAuthHeader() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token != null && token.isNotEmpty) {
        _dio.options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (_) {
      // Ignore token errors; proceed without auth header
    }
  }

  // GET /admin/location - fetch field executives' latest locations
  Future<void> fetchLocations() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      await _attachAuthHeader();

      final response = await _dio.get('/admin/location');
      final data = response.data;

      // Expecting a list of objects with id, name, location (string or lat/lng), lastUpdated
      if (data is List) {
        executives = data.map<Map<String, dynamic>>((item) {
          final map = item as Map<String, dynamic>;
          return {
            'id': (map['id'] ?? '').toString(),
            'name': map['name'] ?? 'Unknown',
            'location': map['location'] ?? _formatLatLng(map),
            'lastUpdated': _parseDate(map['lastUpdated']) ?? DateTime.now(),
          };
        }).toList();
      } else {
        error = 'Unexpected response format';
      }
    } on DioException catch (e) {
      error = e.response?.data?.toString() ?? e.message;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String _formatLatLng(Map<String, dynamic> map) {
    final lat = map['latitude'] ?? map['lat'];
    final lng = map['longitude'] ?? map['lng'] ?? map['lon'];
    if (lat != null && lng != null) {
      return 'Lat: $lat, Lon: $lng';
    }
    return 'Location unavailable';
  }

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    try {
      if (value is String) return DateTime.tryParse(value);
      if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    } catch (_) {}
    return null;
  }
}