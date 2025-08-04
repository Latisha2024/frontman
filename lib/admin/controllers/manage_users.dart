import 'package:flutter/material.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String phone;
  final String status;
  final DateTime createdAt;
  final String? address;
  final String? profileImage;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
    required this.status,
    required this.createdAt,
    this.address,
    this.profileImage,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'phone': phone,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'address': address,
      'profileImage': profileImage,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      phone: json['phone'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      address: json['address'],
      profileImage: json['profileImage'],
    );
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? phone,
    String? status,
    DateTime? createdAt,
    String? address,
    String? profileImage,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      address: address ?? this.address,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}

class AdminManageUsersController extends ChangeNotifier {
  List<User> users = [];
  List<User> filteredUsers = [];
  bool isLoading = false;
  String? error;
  String? successMessage;
  
  String searchQuery = '';
  String selectedRole = 'All';
  String selectedStatus = 'All';
  
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  String selectedUserRole = 'worker';
  String selectedUserStatus = 'active';
  
  User? editingUser;
  bool isEditMode = false;

  final List<String> availableRoles = ['worker', 'external_seller', 'distributor', 'field_executive', 'accountant', 'admin'];
  final List<String> availableStatuses = ['active', 'inactive', 'suspended', 'pending'];

  AdminManageUsersController() {
    users = [];
    filteredUsers = [];
    notifyListeners();
  }

  void searchUsers(String query) {
    searchQuery = query;
    applyFilters();
  }

  void filterByRole(String role) {
    selectedRole = role;
    applyFilters();
  }

  void filterByStatus(String status) {
    selectedStatus = status;
    applyFilters();
  }

  void applyFilters() {
    filteredUsers = users.where((user) {
      bool matchesSearch = searchQuery.isEmpty ||
          user.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          user.email.toLowerCase().contains(searchQuery.toLowerCase()) ||
          user.phone.contains(searchQuery);
      
      bool matchesRole = selectedRole == 'All' || user.role == selectedRole;
      bool matchesStatus = selectedStatus == 'All' || user.status == selectedStatus;
      
      return matchesSearch && matchesRole && matchesStatus;
    }).toList();
    notifyListeners();
  }

  void addUser() {
    if (nameController.text.isEmpty || emailController.text.isEmpty || phoneController.text.isEmpty) {
      error = 'Please fill in all required fields';
      notifyListeners();
      return;
    }

    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      role: selectedUserRole,
      phone: phoneController.text.trim(),
      status: selectedUserStatus,
      createdAt: DateTime.now(),
      address: addressController.text.trim().isEmpty ? null : addressController.text.trim(),
    );

    users.add(newUser);
    applyFilters();
    clearForm();
    successMessage = 'User added successfully!';
    notifyListeners();
  }

  void editUser(User user) {
    editingUser = user;
    isEditMode = true;
    
    nameController.text = user.name;
    emailController.text = user.email;
    phoneController.text = user.phone;
    addressController.text = user.address ?? '';
    selectedUserRole = user.role;
    selectedUserStatus = user.status;
    
    notifyListeners();
  }

  void updateUser() {
    if (editingUser == null) return;
    
    if (nameController.text.isEmpty || emailController.text.isEmpty || phoneController.text.isEmpty) {
      error = 'Please fill in all required fields';
      notifyListeners();
      return;
    }

    final updatedUser = editingUser!.copyWith(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      role: selectedUserRole,
      phone: phoneController.text.trim(),
      status: selectedUserStatus,
      address: addressController.text.trim().isEmpty ? null : addressController.text.trim(),
    );

    final index = users.indexWhere((u) => u.id == editingUser!.id);
    if (index != -1) {
      users[index] = updatedUser;
      applyFilters();
      clearForm();
      successMessage = 'User updated successfully!';
    }
    
    notifyListeners();
  }

  void deleteUser(String userId) {
    users.removeWhere((user) => user.id == userId);
    applyFilters();
    successMessage = 'User deleted successfully!';
    notifyListeners();
  }

  void clearForm() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    addressController.clear();
    selectedUserRole = 'worker';
    selectedUserStatus = 'active';
    editingUser = null;
    isEditMode = false;
    error = null;
    successMessage = null;
    notifyListeners();
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
    super.dispose();
  }
} 