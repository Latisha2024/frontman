import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../admin/user_lookup.dart';
import '../../admin/url.dart';

class SalesManagerGpsTrackingController extends ChangeNotifier {
  // Backend base URL (align with other controllers)
  // Android Emulator: http://10.0.2.2:5000
  // iOS Simulator/Web: http://localhost:5000
  // Physical device: http://<your-PC-LAN-IP>:5000
  static const String baseUrl = BaseUrl.b_url;

  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 8),
    receiveTimeout: const Duration(seconds: 8),
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  // Convenience: accept a user name, resolve to userId, then fetch
  Future<void> fetchLocationsByName(String userName) async {
    final resolved = await UserLookup.resolveUserIdByName(userName.trim());
    if (resolved == null) {
      error = 'User not found for name: $userName';
      notifyListeners();
      return;
    }
    await fetchLocations(resolved);
  }

  // List of location history entries for a selected user
  List<Map<String, dynamic>> locations = [];
  bool isLoading = false;
  String? error;

  Future<void> _attachAuthHeader() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token != null && token.isNotEmpty) {
        _dio.options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (_) {
      // Ignore token errors; proceed without auth header
    }
  }

  // GET /admin/location?userId=... - fetch location history for a specific user
  Future<void> fetchLocations(String userId) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      await _attachAuthHeader();

      if (userId.trim().isEmpty) {
        // No user selected yet; do not treat as an error
        isLoading = false;
        notifyListeners();
        return;
      }

      final response = await _dio.get(
        '/admin/location',
        queryParameters: {'userId': userId},
      );
      final data = response.data;

      // Backend returns array of { id, userId, latitude, longitude, timeStamp }
      if (data is List) {
        locations = data.map<Map<String, dynamic>>((item) {
          final map = item as Map<String, dynamic>;
          return {
            'id': (map['id'] ?? '').toString(),
            'userId': (map['userId'] ?? '').toString(),
            'latitude': map['latitude'],
            'longitude': map['longitude'],
            'timeStamp': _parseDate(map['timeStamp']),
            'label': _formatLatLng(map),
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