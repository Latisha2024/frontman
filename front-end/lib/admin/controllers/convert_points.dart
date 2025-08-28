import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PointTransaction {
  final String id;
  final String userId;
  final int points;
  final double creditAmount;
  final String reason;
  final String type;
  final DateTime date;
  final Map<String, dynamic>? user;

  PointTransaction({
    required this.id,
    required this.userId,
    required this.points,
    required this.creditAmount,
    required this.reason,
    required this.type,
    required this.date,
    this.user,
  });

  factory PointTransaction.fromJson(Map<String, dynamic> json) {
    return PointTransaction(
      id: json['id'].toString(),
      userId: json['userId'].toString(),
      points: json['points'] ?? 0,
      creditAmount: (json['creditAmount'] ?? 0).toDouble(),
      reason: json['reason'] ?? '',
      type: json['type'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      user: json['user'],
    );
  }
}

class AdminConvertPointsController extends ChangeNotifier {
  final userIdController = TextEditingController();
  final pointsController = TextEditingController();
  final reasonController = TextEditingController();

  bool isLoading = false;
  String? error;
  String? successMessage;
  double? convertedAmount;
  List<PointTransaction> _transactions = [];
  List<PointTransaction> get transactions => _transactions;
  int? _userTotalPoints;
  int? get userTotalPoints => _userTotalPoints;
  late final Dio _dio;

  // Base URL - configure based on your backend
  static const String baseUrl = 'http://10.0.2.2:5000';

  AdminConvertPointsController() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
      },
    ));
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token');
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer ' + token;
        }
        return handler.next(options);
      },
    ));
    fetchAllTransactions();
  }

  // GET /admin/points - Fetch all point transactions
  Future<void> fetchAllTransactions({String? userId, String? type}) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final queryParams = <String, dynamic>{};
      if (userId != null && userId.isNotEmpty) queryParams['userId'] = userId;
      if (type != null && type.isNotEmpty) queryParams['type'] = type;

      final response = await _dio.get('/admin/points', queryParameters: queryParams);
      final List<dynamic> data = response.data;
      _transactions = data.map((json) => PointTransaction.fromJson(json)).toList();
      successMessage = 'Transactions loaded successfully';
    } on DioException catch (e) {
      if (e.response != null) {
        error = 'Failed to fetch transactions: ${e.response!.statusCode} - ${e.response!.data}';
      } else {
        error = 'Network error: ${e.message}';
      }
    } catch (e) {
      error = 'Unexpected error: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // GET user points total by calculating from transactions
  Future<void> fetchUserPoints(String userId) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _dio.get('/admin/points', queryParameters: {'userId': userId});
      final List<dynamic> data = response.data;
      final userTransactions = data.map((json) => PointTransaction.fromJson(json)).toList();
      
      // Calculate total points for user
      _userTotalPoints = userTransactions.fold<int>(0, (sum, txn) => sum + txn.points);
      successMessage = 'User points fetched successfully';
    } on DioException catch (e) {
      if (e.response != null) {
        error = 'Failed to fetch user points: ${e.response!.statusCode} - ${e.response!.data}';
      } else {
        error = 'Network error: ${e.message}';
      }
    } catch (e) {
      error = 'Unexpected error: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // POST /admin/points/adjust - Adjust user points
  Future<void> adjustPoints() async {
    if (!validateAdjustForm()) return;

    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final adjustData = {
        'userId': userIdController.text.trim(),
        'points': int.parse(pointsController.text.trim()),
        'reason': reasonController.text.trim(),
      };

      final response = await _dio.post('/admin/points/adjust', data: adjustData);
      final responseData = response.data;
      successMessage = responseData['message'] ?? 'Points adjusted successfully';
      clearForm();
      await fetchAllTransactions(); // Refresh the list
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        error = responseData['message'] ?? 'Failed to adjust points: ${e.response!.statusCode}';
      } else {
        error = 'Network error: ${e.message}';
      }
    } catch (e) {
      error = 'Unexpected error: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> convertPointsToCash() async {
    if (!validateConvertForm()) return;

    try {
      isLoading = true;
      error = null;
      successMessage = null;
      convertedAmount = null;
      notifyListeners();

      final payload = {
        'userId': userIdController.text.trim(),
        'points': double.parse(pointsController.text.trim()),
      };

      // Expected backend route
      final response = await _dio.post('/admin/points/convert', data: payload);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data is Map<String, dynamic> ? response.data as Map<String, dynamic> : <String, dynamic>{};
        // Try common keys
        final amt = data['convertedAmount'] ?? data['amount'] ?? data['creditAmount'];
        convertedAmount = (amt is num) ? amt.toDouble() : null;
        successMessage = data['message'] ?? 'Points converted successfully!';
        // Refresh transactions to reflect the conversion entry
        await fetchAllTransactions(userId: userIdController.text.trim());
      } else {
        error = 'Failed to convert points: ${response.statusCode}';
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final data = e.response!.data;
        if (data is Map && data['message'] is String) {
          error = data['message'];
        } else {
          error = 'Conversion failed: ${e.response!.statusCode}';
        }
      } else {
        error = 'Network error: ${e.message}';
      }
    } catch (e) {
      error = 'Unexpected error: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool validateAdjustForm() {
    error = null;
    if (userIdController.text.trim().isEmpty ||
        pointsController.text.trim().isEmpty ||
        reasonController.text.trim().isEmpty) {
      error = 'Please fill in all required fields.';
      notifyListeners();
      return false;
    }
    final points = int.tryParse(pointsController.text.trim());
    if (points == null) {
      error = 'Points must be a valid integer.';
      notifyListeners();
      return false;
    }
    return true;
  }

  bool validateConvertForm() {
    error = null;
    if (userIdController.text.trim().isEmpty || pointsController.text.trim().isEmpty) {
      error = 'Please enter both User ID and Points.';
      notifyListeners();
      return false;
    }
    final points = double.tryParse(pointsController.text.trim());
    if (points == null || points <= 0) {
      error = 'Points must be a positive number.';
      notifyListeners();
      return false;
    }
    return true;
  }

  void clearForm() {
    userIdController.clear();
    pointsController.clear();
    reasonController.clear();
    error = null;
    successMessage = null;
    convertedAmount = null;
    _userTotalPoints = null;
    notifyListeners();
  }

  void clearMessages() {
    error = null;
    successMessage = null;
  }

  @override
  void dispose() {
    userIdController.dispose();
    pointsController.dispose();
    reasonController.dispose();
    super.dispose();
  }
}