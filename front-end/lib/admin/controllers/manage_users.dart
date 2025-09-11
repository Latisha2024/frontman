import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../url.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String role;
  final String? address;
  final String status;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    this.address,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'address': address,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      role: json['role'] ?? '',
      address: json['address'],
      status: json['status'] ?? 'active',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? role,
    String? address,
    String? status,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      address: address ?? this.address,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AdminManageUsersController extends ChangeNotifier {
  List<User> _users = [];
  late final Dio _dio;
  bool isLoading = false;
  String? error;
  String? successMessage;
  String selectedUserRole = 'Worker';
  String selectedUserStatus = 'active';
  String _searchQuery = '';
  String selectedRole = 'All';
  String selectedStatus = 'All';
  
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  User? _editingUser;
  bool _isEditMode = false;
  // Getters
  List<User> get users => _users;
  bool get isEditMode => _isEditMode;
  
  List<User> get filteredUsers {
    List<User> filtered = _users;
    
    // Filter by role
    if (selectedRole != 'All') {
      filtered = filtered.where((user) => user.role == selectedRole).toList();
    }
    
    // Filter by status
    if (selectedStatus != 'All') {
      filtered = filtered.where((user) => user.status == selectedStatus).toList();
    }
    
    
    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((user) {
        return user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               user.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               (user.phone?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
               (user.address?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      }).toList();
    }
    
    return filtered;
  }

  List<String> get availableRoles => [
    'Admin',
    'SalesManager', 
    'Worker',
    'Accountant',
    'Distributor',
    'FieldExecutive',
    'Plumber'
  ];

  List<String> get availableStatuses => ['active', 'inactive', 'suspended', 'pending'];

  // Base URL - configure based on your backend
  static const String baseUrl = BaseUrl.b_url;

  AdminManageUsersController() {
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
    fetchUsers();
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

  // GET /admin/users
  Future<void> fetchUsers({String? role}) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      Map<String, dynamic> queryParams = {};
      if (role != null && role != 'All') {
        queryParams['role'] = role;
      }

      final response = await _dio.get(
        '/admin/users',
        queryParameters: queryParams,
      );

      final List<dynamic> data = response.data;
      _users = data.map((json) => User.fromJson(json)).toList();
      notifyListeners();
      successMessage = 'Users loaded successfully';
      _scheduleAutoHideMessages();
    } on DioException catch (e) {
      if (e.response != null) {
        error = 'Failed to fetch users: ${e.response!.statusCode} - ${e.response!.data}';
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

  void searchUsers(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void filterByRole(String role) {
    selectedRole = role;
    notifyListeners();
  }

  void filterByStatus(String status) {
    selectedStatus = status;
    notifyListeners();
  }

  // POST /admin/users
  Future<void> addUser() async {
    if (nameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty) {
      error = 'Name, email, and password are required';
      notifyListeners();
      _scheduleAutoHideMessages();
      return;
    }

    try {
      isLoading = true;
      error = null;
      notifyListeners();

      // Enforce unique user name (case-insensitive)
      final newName = nameController.text.trim();
      final newNameLower = newName.toLowerCase();
      // Check locally first
      final localDuplicate = _users.any((u) => u.name.toLowerCase() == newNameLower);
      if (localDuplicate) {
        error = 'User name already exists. Please choose a different name.';
        notifyListeners();
        _scheduleAutoHideMessages();
        isLoading = false;
        notifyListeners();
        return;
      }

      // Double-check via backend search to avoid race conditions
      try {
        final resp = await _dio.get(
          '/admin/search/users',
          queryParameters: {'q': newName},
        );
        if (resp.data is List) {
          final List list = resp.data as List;
          final exists = list.any((item) {
            final map = item as Map<String, dynamic>;
            final nm = (map['name'] ?? '').toString().toLowerCase();
            return nm == newNameLower;
          });
          if (exists) {
            error = 'User name already exists. Please choose a different name.';
            notifyListeners();
            _scheduleAutoHideMessages();
            isLoading = false;
            notifyListeners();
            return;
          }
        }
      } catch (_) {
        // If search endpoint fails, proceed to creation; backend should still enforce if supported
      }

      final userData = {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim().isNotEmpty ? phoneController.text.trim() : null,
        'address': addressController.text.trim().isNotEmpty ? addressController.text.trim() : null,
        'role': selectedUserRole,
        'status': selectedUserStatus,
        'password': passwordController.text.trim(),
      };

      final response = await _dio.post(
        '/admin/users',
        data: userData,
      );

      final responseData = response.data;
      successMessage = responseData['message'] ?? 'User created successfully';
      clearForm();
      await fetchUsers(); // Refresh the list
      _scheduleAutoHideMessages();
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        error = responseData['message'] ?? 'Failed to create user: ${e.response!.statusCode}';
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

  void editUser(User user) {
    _editingUser = user;
    nameController.text = user.name;
    emailController.text = user.email;
    phoneController.text = user.phone ?? '';
    addressController.text = user.address ?? '';
    selectedUserRole = user.role;
    selectedUserStatus = user.status;
    passwordController.clear(); // Don't pre-fill password for security
    _isEditMode = true;
    clearMessages();
    notifyListeners();
  }

  // PUT /admin/users/:id
  Future<void> updateUser() async {
    if (_editingUser == null) return;
    
    if (nameController.text.isEmpty || emailController.text.isEmpty) {
      error = 'Name and email are required';
      notifyListeners();
      _scheduleAutoHideMessages();
      return;
    }

    try {
      isLoading = true;
      error = null;
      notifyListeners();
      final updateData = {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim().isNotEmpty ? phoneController.text.trim() : null,
        'address': addressController.text.trim().isNotEmpty ? addressController.text.trim() : null,
        'role': selectedUserRole,
        'status': selectedUserStatus,
      };
      
      // Only include password if it's provided
      if (passwordController.text.trim().isNotEmpty) {
        updateData['password'] = passwordController.text.trim();
      }

      final response = await _dio.put(
        '/admin/users/${_editingUser!.id}',
        data: updateData,
      );

      final responseData = response.data;
      successMessage = responseData['message'] ?? 'User updated successfully';
      clearForm();
      await fetchUsers(); // Refresh the list
      _scheduleAutoHideMessages();
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        error = responseData['message'] ?? 'Failed to update user: ${e.response!.statusCode}';
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

  // DELETE /admin/users/:id
  Future<void> deleteUser(String userId) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      final response = await _dio.delete(
        '/admin/users/$userId',
      );

      final responseData = response.data;
      successMessage = responseData['message'] ?? 'User deleted successfully';
      await fetchUsers(); // Refresh the list
      _scheduleAutoHideMessages();
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        error = responseData['message'] ?? 'Failed to delete user: ${e.response!.statusCode}';
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

  void clearForm() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    addressController.clear();
    passwordController.clear();
    selectedUserRole = 'Worker';
    selectedUserStatus = 'active';
    _editingUser = null;
    _isEditMode = false;
    clearMessages();
    notifyListeners();
  }

  // GET /admin/search/users - Search users with query
  Future<List<User>> searchUsersApi(String query, {String? role, String? status}) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final queryParams = <String, dynamic>{
        'q': query,
      };
      if (role != null && role != 'All') queryParams['role'] = role;
      if (status != null && status != 'All') queryParams['status'] = status;

      final response = await _dio.get(
        '/admin/search/users',
        queryParameters: queryParams,
      );

      final List<dynamic> data = response.data;
      final searchResults = data.map((json) => User.fromJson(json)).toList();
      successMessage = 'User search completed successfully';
      _scheduleAutoHideMessages();
      return searchResults;
    } on DioException catch (e) {
      if (e.response != null) {
        error = 'Failed to search users: ${e.response!.statusCode} - ${e.response!.data}';
      } else {
        error = 'Network error: ${e.message}';
      }
      _scheduleAutoHideMessages();
      return [];
    } catch (e) {
      error = 'Unexpected error: $e';
      _scheduleAutoHideMessages();
      return [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    error = null;
    successMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}