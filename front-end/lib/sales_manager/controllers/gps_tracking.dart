import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../admin/user_lookup.dart';
import '../../admin/url.dart';

class SalesManagerGpsTrackingController extends ChangeNotifier {
  static const String baseUrl = BaseUrl.b_url;

  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 8),
    receiveTimeout: const Duration(seconds: 8),
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  Future<void> fetchLocationsByName(String userName) async {
    final resolved = await UserLookup.resolveUserIdByName(userName.trim());
    if (resolved == null) {
      error = 'User not found for name: $userName';
      notifyListeners();
      return;
    }
    await fetchLocations(resolved);
  }

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
    }
  }

  Future<void> fetchLocations(String userId) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      await _attachAuthHeader();

      if (userId.trim().isEmpty) {
        isLoading = false;
        notifyListeners();
        return;
      }

      final response = await _dio.get(
        '/admin/location',
        queryParameters: {'userId': userId},
      );
      final data = response.data;

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