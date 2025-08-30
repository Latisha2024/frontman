import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String role;
  final String companyId;
  final String? address;
  final String status;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    required this.companyId,
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
      'companyId': companyId,
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
      companyId: json['companyId'] ?? 'company1',
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
    String? companyId,
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
      companyId: companyId ?? this.companyId,
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
  static const String baseUrl = 'http://10.0.2.2:5000';

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
    } on DioException catch (e) {
      if (e.response != null) {
        error =
            'Failed to fetch users: ${e.response!.statusCode} - ${e.response!.data}';
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
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      error = 'Name, email, and password are required';
      notifyListeners();
      return;
    }

    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final userData = {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim().isNotEmpty
            ? phoneController.text.trim()
            : null,
        'address': addressController.text.trim().isNotEmpty
            ? addressController.text.trim()
            : null,
        'role': selectedUserRole,
        'companyId': 'company1',
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
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        error = responseData['message'] ??
            'Failed to create user: ${e.response!.statusCode}';
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
      return;
    }

    try {
      isLoading = true;
      error = null;
      notifyListeners();
      final updateData = {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim().isNotEmpty
            ? phoneController.text.trim()
            : null,
        'address': addressController.text.trim().isNotEmpty
            ? addressController.text.trim()
            : null,
        'role': selectedUserRole,
        'companyId': 'company1',
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
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        error = responseData['message'] ??
            'Failed to update user: ${e.response!.statusCode}';
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
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        error = responseData['message'] ??
            'Failed to delete user: ${e.response!.statusCode}';
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
  Future<List<User>> searchUsersApi(String query,
      {String? role, String? status}) async {
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
      return searchResults;
    } on DioException catch (e) {
      if (e.response != null) {
        error =
            'Failed to search users: ${e.response!.statusCode} - ${e.response!.data}';
      } else {
        error = 'Network error: ${e.message}';
      }
      return [];
    } catch (e) {
      error = 'Unexpected error: $e';
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
