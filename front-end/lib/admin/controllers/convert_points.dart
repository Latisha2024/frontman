import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../user_lookup.dart';

import '../url.dart';

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
  final conversionRateController = TextEditingController();
  final reasonController = TextEditingController();

  bool isLoading = false;
  String? error;
  String? successMessage;
  double? convertedAmount;
  List<PointTransaction> _transactions = [];
  List<PointTransaction> get transactions => _transactions;
  List<PointTransaction> filteredTransactions = [];
  String searchQuery = '';
  int? _userTotalPoints;
  int? get userTotalPoints => _userTotalPoints;
  late final Dio _dio;

  // Base URL - configure based on your backend
  static const String baseUrl = BaseUrl.b_url;

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

  void _scheduleAutoHideMessages() {
    Future.delayed(const Duration(seconds: 3), () {
      if (error != null || successMessage != null) {
        error = null;
        successMessage = null;
        notifyListeners();
      }
    });
  }

  // GET /admin/points - Fetch all point transactions (userId filter removed)
  Future<void> fetchAllTransactions({String? type}) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final queryParams = <String, dynamic>{};
      if (type != null && type.isNotEmpty) queryParams['type'] = type;

      final response = await _dio.get('/admin/points', queryParameters: queryParams);
      final List<dynamic> data = response.data;
      _transactions = data.map((json) => PointTransaction.fromJson(json)).toList();
      _applyLocalSearch();
      successMessage = 'Transactions loaded successfully';
      _scheduleAutoHideMessages();
    } on DioException catch (e) {
      if (e.response != null) {
        error = 'Failed to fetch transactions: ${e.response!.statusCode} - ${e.response!.data}';
      } else {
        error = 'Network error: ${e.message}';
      }
      _scheduleAutoHideMessages();
    } catch (e) {
      error = 'Unexpected error: $e';
      _scheduleAutoHideMessages();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Local search API for transactions
  void searchTransactions(String query) {
    searchQuery = query;
    _applyLocalSearch();
  }

  void _applyLocalSearch() {
    if (searchQuery.isEmpty) {
      filteredTransactions = List.from(_transactions);
    } else {
      final q = searchQuery.toLowerCase();
      filteredTransactions = _transactions.where((t) {
        final name = t.user?['name']?.toString().toLowerCase() ?? '';
        final uid = t.userId.toLowerCase();
        final reason = t.reason.toLowerCase();
        final type = t.type.toLowerCase();
        final points = t.points.toString();
        return name.contains(q) || uid.contains(q) || reason.contains(q) || type.contains(q) || points.contains(q);
      }).toList();
    }
    notifyListeners();
  }

  // GET user points total by calculating from transactions
  // Accepts username or userId; resolves username to id before computing.
  Future<void> fetchUserPoints(String userInput) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      // Reuse loaded transactions; if empty, load all and then filter locally
      if (_transactions.isEmpty) {
        await fetchAllTransactions();
      }
      // Resolve username to userId if possible
      String resolved = userInput.trim();
      final lookedUp = await UserLookup.resolveUserIdByName(resolved);
      if (lookedUp != null) {
        resolved = lookedUp;
      }
      final userTransactions = _transactions.where((t) => t.userId == resolved).toList();
      
      // Calculate total points for user
      _userTotalPoints = userTransactions.fold<int>(0, (sum, txn) => sum + txn.points);
      successMessage = 'User points fetched successfully';
      _scheduleAutoHideMessages();
    } on DioException catch (e) {
      if (e.response != null) {
        error = 'Failed to fetch user points: ${e.response!.statusCode} - ${e.response!.data}';
      } else {
        error = 'Network error: ${e.message}';
      }
      _scheduleAutoHideMessages();
    } catch (e) {
      error = 'Unexpected error: $e';
      _scheduleAutoHideMessages();
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

      // Resolve username to userId if needed
      String resolvedUserId = userIdController.text.trim();
      final lookedUp = await UserLookup.resolveUserIdByName(resolvedUserId);
      if (lookedUp != null) {
        resolvedUserId = lookedUp;
      }

      final adjustData = {
        'userId': resolvedUserId,
        'points': int.parse(pointsController.text.trim()),
        'reason': reasonController.text.trim(),
      };

      final response = await _dio.post('/admin/points/adjust', data: adjustData);
      final responseData = response.data;
      successMessage = responseData['message'] ?? 'Points adjusted successfully';
      clearForm();
      await fetchAllTransactions(); // Refresh the list
      _scheduleAutoHideMessages();
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        error = responseData['message'] ?? 'Failed to adjust points: ${e.response!.statusCode}';
      } else {
        error = 'Network error: ${e.message}';
      }
      _scheduleAutoHideMessages();
    } catch (e) {
      error = 'Unexpected error: $e';
      _scheduleAutoHideMessages();
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

      final parsedPoints = int.parse(pointsController.text.trim());
      final parsedRate = double.parse(conversionRateController.text.trim());
      final reason = reasonController.text.trim();

      // Resolve username to userId if needed
      String resolvedUserId = userIdController.text.trim();
      final lookedUp = await UserLookup.resolveUserIdByName(resolvedUserId);
      if (lookedUp != null) {
        resolvedUserId = lookedUp;
      }

      final payload = <String, dynamic>{
        'userId': resolvedUserId,
        'points': parsedPoints,
        'conversionRate': parsedRate,
      };
      if (reason.isNotEmpty) payload['reason'] = reason;

      // Expected backend route
      final response = await _dio.post('/admin/points/convert', data: payload);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data is Map<String, dynamic> ? response.data as Map<String, dynamic> : <String, dynamic>{};
        // Backend returns cashAmount
        final amt = data['cashAmount'] ?? data['convertedAmount'] ?? data['amount'] ?? data['creditAmount'];
        convertedAmount = (amt is num) ? amt.toDouble() : null;
        successMessage = data['message'] ?? 'Points converted successfully!';
        // Refresh transactions to reflect the conversion entry
        await fetchAllTransactions();
        _scheduleAutoHideMessages();
      } else {
        error = 'Failed to convert points: ${response.statusCode}';
        _scheduleAutoHideMessages();
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
      _scheduleAutoHideMessages();
    } catch (e) {
      error = 'Unexpected error: $e';
      _scheduleAutoHideMessages();
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
      _scheduleAutoHideMessages();
      return false;
    }
    final points = int.tryParse(pointsController.text.trim());
    if (points == null) {
      error = 'Points must be a valid integer.';
      notifyListeners();
      _scheduleAutoHideMessages();
      return false;
    }
    return true;
  }

  bool validateConvertForm() {
    error = null;
    if (userIdController.text.trim().isEmpty || pointsController.text.trim().isEmpty || conversionRateController.text.trim().isEmpty) {
      error = 'Please enter User ID, Points, and Conversion Rate.';
      notifyListeners();
      _scheduleAutoHideMessages();
      return false;
    }
    final points = int.tryParse(pointsController.text.trim());
    if (points == null || points <= 0) {
      error = 'Points must be a positive integer.';
      notifyListeners();
      _scheduleAutoHideMessages();
      return false;
    }
    final rate = double.tryParse(conversionRateController.text.trim());
    if (rate == null || rate <= 0) {
      error = 'Conversion rate must be a positive number.';
      notifyListeners();
      _scheduleAutoHideMessages();
      return false;
    }
    return true;
  }

  void clearForm() {
    userIdController.clear();
    pointsController.clear();
    conversionRateController.clear();
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
    conversionRateController.dispose();
    reasonController.dispose();
    super.dispose();
  }
}