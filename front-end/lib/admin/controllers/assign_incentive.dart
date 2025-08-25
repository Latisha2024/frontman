import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Incentive {
  final String id;
  final String assignedId;
  final String description;
  final int points;
  final DateTime assignedAt;
  final Map<String, dynamic>? assignedTo;

  Incentive({
    required this.id,
    required this.assignedId,
    required this.description,
    required this.points,
    required this.assignedAt,
    this.assignedTo,
  });

  factory Incentive.fromJson(Map<String, dynamic> json) {
    return Incentive(
      id: json['id'].toString(),
      assignedId: json['assignedId'].toString(),
      description: json['description'] ?? '',
      points: json['points'] ?? 0,
      assignedAt: DateTime.parse(json['assignedAt']),
      assignedTo: json['assignedTo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assignedId': assignedId,
      'description': description,
      'points': points,
      'assignedAt': assignedAt.toIso8601String(),
      'assignedTo': assignedTo,
    };
  }
}

class AdminAssignIncentiveController extends ChangeNotifier {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:5000'));
  
  bool isLoading = false;
  String? error;
  String? successMessage;
  List<Incentive> incentives = [];
  List<Incentive> filteredIncentives = [];
  
  final userIdController = TextEditingController();
  final pointsController = TextEditingController();
  final descriptionController = TextEditingController();
  final filterUserIdController = TextEditingController();

  AdminAssignIncentiveController() {
    fetchAllIncentives();
  }

  // GET /admin/incentives - Fetch all incentives
  Future<void> fetchAllIncentives() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _dio.get('/admin/incentives');
      final List<dynamic> data = response.data;
      incentives = data.map((json) => Incentive.fromJson(json)).toList();
      filteredIncentives = List.from(incentives);
      
      successMessage = 'Incentives loaded successfully';
    } on DioException catch (e) {
      if (e.response != null) {
        error = 'Failed to fetch incentives: ${e.response!.statusCode} - ${e.response!.data}';
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

  // GET /admin/incentives?userId=... - Filter incentives by user
  Future<void> filterIncentivesByUser(String userId) async {
    if (userId.isEmpty) {
      filteredIncentives = List.from(incentives);
      notifyListeners();
      return;
    }

    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _dio.get('/admin/incentives', queryParameters: {'userId': userId});
      final List<dynamic> data = response.data;
      filteredIncentives = data.map((json) => Incentive.fromJson(json)).toList();
      
    } on DioException catch (e) {
      if (e.response != null) {
        error = 'Failed to filter incentives: ${e.response!.statusCode} - ${e.response!.data}';
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

  // POST /admin/incentives - Assign new incentive
  Future<void> assignIncentive() async {
    final userId = userIdController.text.trim();
    final points = int.tryParse(pointsController.text.trim());
    final description = descriptionController.text.trim();
    
    if (userId.isEmpty || points == null || points <= 0 || description.isEmpty) {
      error = 'Please fill all fields with valid data.';
      notifyListeners();
      return;
    }

    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _dio.post('/admin/incentives', data: {
        'assignedId': userId,
        'description': description,
        'points': points,
      });

      if (response.statusCode == 201) {
        successMessage = 'Incentive assigned successfully!';
        clearForm();
        await fetchAllIncentives(); // Refresh the list
      }
    } on DioException catch (e) {
      if (e.response != null) {
        error = 'Failed to assign incentive: ${e.response!.statusCode} - ${e.response!.data}';
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

  void clearForm() {
    userIdController.clear();
    pointsController.clear();
    descriptionController.clear();
  }

  void clearMessages() {
    error = null;
    successMessage = null;
    notifyListeners();
  }

  void searchIncentives(String query) {
    if (query.isEmpty) {
      filteredIncentives = List.from(incentives);
    } else {
      filteredIncentives = incentives.where((incentive) {
        final description = incentive.description.toLowerCase();
        final userId = incentive.assignedId.toLowerCase();
        final userName = incentive.assignedTo?['name']?.toString().toLowerCase() ?? '';
        final searchQuery = query.toLowerCase();
        
        return description.contains(searchQuery) || 
               userId.contains(searchQuery) || 
               userName.contains(searchQuery);
      }).toList();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    userIdController.dispose();
    pointsController.dispose();
    descriptionController.dispose();
    filterUserIdController.dispose();
    super.dispose();
  }
}