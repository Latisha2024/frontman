import 'package:flutter/material.dart';

class OrderSummary {
  final String id;
  final String customer;
  final DateTime date;
  final double total;
  final String status;

  OrderSummary({
    required this.id,
    required this.customer,
    required this.date,
    required this.total,
    required this.status,
  });
}

class AdminOrderSummaryController extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  String? successMessage;
  List<OrderSummary> orders = [];
  List<OrderSummary> filteredOrders = [];
  String searchQuery = '';
  String selectedStatus = 'All';
  final List<String> availableStatuses = ['All', 'Completed', 'Pending', 'Cancelled'];

  AdminOrderSummaryController() {
    // Initialize with dummy order summary data
    orders = [
      OrderSummary(
        id: 'ORD-2024-001',
        customer: 'John Smith',
        date: DateTime.now().subtract(const Duration(days: 10)),
        total: 2359.97,
        status: 'Completed',
      ),
    ];
    filteredOrders = List.from(orders);
  }

  void searchOrders(String query) {
    searchQuery = query;
    applyFilters();
  }

  void filterByStatus(String status) {
    selectedStatus = status;
    applyFilters();
  }

  void applyFilters() {
    filteredOrders = orders.where((order) {
      bool matchesSearch = searchQuery.isEmpty ||
          order.id.toLowerCase().contains(searchQuery.toLowerCase()) ||
          order.customer.toLowerCase().contains(searchQuery.toLowerCase());
      bool matchesStatus = selectedStatus == 'All' || order.status == selectedStatus;
      return matchesSearch && matchesStatus;
    }).toList();
    notifyListeners();
  }

  void clearMessages() {
    error = null;
    successMessage = null;
    notifyListeners();
  }
} 