import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'url.dart' as admin_url;

class UserLookup {
  static Dio _buildDio() {
    final dio = Dio(BaseOptions(
      baseUrl: admin_url.BaseUrl.b_url,
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8),
      headers: {'Content-Type': 'application/json'},
    ));
    return dio;
  }

  static Future<void> _attachAuth(Dio dio) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token != null && token.isNotEmpty) {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  // Resolves a username (display name) to userId by querying /admin/search/users?q=
  // Returns null if not found or on error.
  static Future<String?> resolveUserIdByName(String name) async {
    if (name.trim().isEmpty) return null;
    final dio = _buildDio();
    await _attachAuth(dio);
    try {
      final resp = await dio.get('/admin/search/users', queryParameters: {'q': name});
      if (resp.data is List) {
        final List list = resp.data as List;
        if (list.isEmpty) return null;
        // Prefer exact (case-insensitive) name match; fallback to first result
        final lower = name.toLowerCase();
        final exact = list.cast<Map>().firstWhere(
          (u) => (u['name']?.toString().toLowerCase() ?? '') == lower,
          orElse: () => list.first as Map,
        );
        return exact['id']?.toString();
      }
    } catch (_) {
      // ignore
    }
    return null;
  }
}
