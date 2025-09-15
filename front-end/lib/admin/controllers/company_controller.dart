import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../url.dart';

class Company {
  final String id;
  final String name;
  final String description;
  final String? logoUrl;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Company({
    required this.id,
    required this.name,
    this.description = '',
    this.logoUrl,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    bool parseIsActive(dynamic v) {
      if (v == null) return true; // Default to true when field is missing in list API
      if (v is bool) return v;
      return v.toString().toLowerCase() == 'true';
    }

    return Company(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: (json['description'] ?? '').toString(),
      logoUrl: json['logoUrl']?.toString(),
      isActive: parseIsActive(json['isActive']),
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'].toString()) : null,
    );
  }
}

class CompanyController {
  static const String baseUrl = '${BaseUrl.b_url}admin/companies';

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<List<Company>> getCompanies() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer ' + token,
      },
    );

    if (response.statusCode == 200) {
      final dynamic body = json.decode(response.body);
      final List<dynamic> data = body is List ? body : (body['data'] as List? ?? body as List? ?? []);
      return data.map((e) => Company.fromJson(e as Map<String, dynamic>)).toList();
    }

    try {
      final err = json.decode(response.body);
      final msg = err['message'] ?? err['error'] ?? response.reasonPhrase ?? 'Unknown error';
      throw Exception('Failed to load companies: $msg');
    } catch (_) {
      throw Exception('Failed to load companies: ${response.statusCode}');
    }
  }

  static Future<Company?> getCurrentCompany() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/current'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer ' + token,
      },
    );

    if (response.statusCode == 200) {
      final dynamic body = json.decode(response.body);
      final Map<String, dynamic> companyJson =
          body is Map<String, dynamic> && body['company'] is Map<String, dynamic>
              ? body['company'] as Map<String, dynamic>
              : (body as Map<String, dynamic>);
      return Company.fromJson(companyJson);
    }

    // It's okay if not set
    return null;
  }

  static Future<void> switchCompany(String companyId) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/$companyId/switch'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer ' + token,
      },
    );

    if (response.statusCode == 200) {
      return;
    }

    try {
      final err = json.decode(response.body);
      final msg = err['message'] ?? err['error'] ?? response.reasonPhrase ?? 'Unknown error';
      throw Exception('Failed to switch company: $msg');
    } catch (_) {
      throw Exception('Failed to switch company: ${response.statusCode}');
    }
  }

  // GET /admin/companies/:id - Get company by ID
  static Future<Company> getCompanyById(String id) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer ' + token,
      },
    );

    if (response.statusCode == 200) {
      final dynamic body = json.decode(response.body);
      final Map<String, dynamic> data = body as Map<String, dynamic>;
      return Company.fromJson(data);
    }

    try {
      final err = json.decode(response.body);
      final msg = err['message'] ?? err['error'] ?? response.reasonPhrase ?? 'Unknown error';
      throw Exception('Failed to fetch company: $msg');
    } catch (_) {
      throw Exception('Failed to fetch company: ${response.statusCode}');
    }
  }

  // POST /admin/companies - Create new company
  static Future<Company> createCompany({
    required String name,
    String description = '',
    String? logoUrl,
  }) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer ' + token,
      },
      body: json.encode({
        'name': name.trim(),
        'description': description.trim(),
        if (logoUrl != null) 'logoUrl': logoUrl.trim(),
      }),
    );

    if (response.statusCode == 201) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final companyJson = body['company'] as Map<String, dynamic>? ?? body;
      return Company.fromJson(companyJson);
    }

    try {
      final err = json.decode(response.body);
      final msg = err['message'] ?? err['error'] ?? response.reasonPhrase ?? 'Unknown error';
      throw Exception('Failed to create company: $msg');
    } catch (_) {
      throw Exception('Failed to create company: ${response.statusCode}');
    }
  }

  // PUT /admin/companies/:id - Update company
  static Future<Company> updateCompany({
    required String id,
    String? name,
    String? description,
    String? logoUrl,
    bool? isActive,
  }) async {
    final token = await _getToken();
    final Map<String, dynamic> payload = {};
    if (name != null) payload['name'] = name.trim();
    if (description != null) payload['description'] = description.trim();
    if (logoUrl != null) payload['logoUrl'] = logoUrl.trim();
    if (isActive != null) payload['isActive'] = isActive;

    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer ' + token,
      },
      body: json.encode(payload),
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final companyJson = body['company'] as Map<String, dynamic>? ?? body;
      return Company.fromJson(companyJson);
    }

    try {
      final err = json.decode(response.body);
      final msg = err['message'] ?? err['error'] ?? response.reasonPhrase ?? 'Unknown error';
      throw Exception('Failed to update company: $msg');
    } catch (_) {
      throw Exception('Failed to update company: ${response.statusCode}');
    }
  }

  // DELETE /admin/companies/:id - Soft delete company
  static Future<void> deleteCompany(String id) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer ' + token,
      },
    );

    if (response.statusCode == 200) {
      return;
    }

    try {
      final err = json.decode(response.body);
      final msg = err['message'] ?? err['error'] ?? response.reasonPhrase ?? 'Unknown error';
      throw Exception('Failed to delete company: $msg');
    } catch (_) {
      throw Exception('Failed to delete company: ${response.statusCode}');
    }
  }

  // POST /admin/companies/:id/assign-admin - Assign admin to company
  static Future<void> assignAdminToCompany({
    required String companyId,
    required String adminId,
  }) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/$companyId/assign-admin'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer ' + token,
      },
      body: json.encode({'adminId': adminId.trim()}),
    );

    if (response.statusCode == 200) {
      return;
    }

    try {
      final err = json.decode(response.body);
      final msg = err['message'] ?? err['error'] ?? response.reasonPhrase ?? 'Unknown error';
      throw Exception('Failed to assign admin: $msg');
    } catch (_) {
      throw Exception('Failed to assign admin: ${response.statusCode}');
    }
  }
}
