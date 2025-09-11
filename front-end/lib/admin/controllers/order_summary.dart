import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../url.dart';

class Order {
  final String id;
  final String userId;
  final DateTime orderDate;
  final String status;
  final double totalAmount;
  final Map<String, dynamic>? user;
  final List<OrderItem> orderItems;
  final Map<String, dynamic>? invoice;

  Order({
    required this.id,
    required this.userId,
    required this.orderDate,
    required this.status,
    required this.totalAmount,
    this.user,
    required this.orderItems,
    this.invoice,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final orderItems = (json['orderItems'] as List<dynamic>? ?? [])
        .map((item) => OrderItem.fromJson(item))
        .toList();
    
    // Calculate total amount from order items
    final total = orderItems.fold<double>(0.0, (sum, item) => sum + (item.unitPrice * item.quantity));
    
    return Order(
      id: json['id'].toString(),
      userId: json['userId'].toString(),
      orderDate: DateTime.parse(json['orderDate']),
      status: json['status'] ?? 'Pending',
      totalAmount: total,
      user: json['user'],
      orderItems: orderItems,
      invoice: json['invoice'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'orderDate': orderDate.toIso8601String(),
      'status': status,
      'totalAmount': totalAmount,
      'user': user,
      'orderItems': orderItems.map((item) => item.toJson()).toList(),
      'invoice': invoice,
    };
  }
}

class OrderItem {
  final String productId;
  final int quantity;
  final double unitPrice;
  final Map<String, dynamic>? product;

  OrderItem({
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    this.product,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'].toString(),
      quantity: json['quantity'] ?? 0,
      unitPrice: (json['unitPrice'] ?? 0).toDouble(),
      product: json['product'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'product': product,
    };
  }
}

class AdminOrderSummaryController extends ChangeNotifier {
  final Dio _dio = Dio(BaseOptions(baseUrl: BaseUrl.b_url));
  
  bool isLoading = false;
  String? error;
  String? successMessage;
  List<Order> orders = [];
  List<Order> filteredOrders = [];
  String searchQuery = '';
  String selectedStatus = 'All';
  final List<String> availableStatuses = ['All', 'Pending', 'Completed', 'Cancelled'];
  String filterUserId = '';
  final filterUserIdController = TextEditingController();

  AdminOrderSummaryController() {
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
    fetchAllOrders();
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

  // GET /admin/orders - Fetch all orders
  Future<void> fetchAllOrders() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _dio.get('/admin/orders');
      final List<dynamic> data = response.data;
      orders = data.map((json) => Order.fromJson(json)).toList();
      filteredOrders = List.from(orders);
      
      successMessage = 'Orders loaded successfully';
      _scheduleAutoHideMessages();
    } on DioException catch (e) {
      if (e.response != null) {
        error = 'Failed to fetch orders: ${e.response!.statusCode} - ${e.response!.data}';
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

  // GET /admin/orders with filters (userId removed as per requirement)
  Future<void> fetchOrdersWithFilters({String? status}) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final queryParams = <String, dynamic>{};
      if (status != null && status != 'All') queryParams['status'] = status;

      final response = await _dio.get('/admin/orders', queryParameters: queryParams);
      final List<dynamic> data = response.data;
      filteredOrders = data.map((json) => Order.fromJson(json)).toList();
      
    } on DioException catch (e) {
      if (e.response != null) {
        error = 'Failed to filter orders: ${e.response!.statusCode} - ${e.response!.data}';
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

  // GET /admin/orders/:id - Get specific order
  Future<Order?> fetchOrderById(String orderId) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _dio.get('/admin/orders/$orderId');
      return Order.fromJson(response.data);
      
    } on DioException catch (e) {
      if (e.response != null) {
        error = 'Failed to fetch order: ${e.response!.statusCode} - ${e.response!.data}';
      } else {
        error = 'Network error: ${e.message}';
      }
      _scheduleAutoHideMessages();
      return null;
    } catch (e) {
      error = 'Unexpected error: $e';
      _scheduleAutoHideMessages();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void searchOrders(String query) {
    searchQuery = query;
    applyLocalFilters();
  }

  void filterByStatus(String status) {
    selectedStatus = status;
    // Use backend filtering for better performance
    fetchOrdersWithFilters(
      status: status,
    );
  }

  void filterByUserId() {
    // userId filter removed; simply refresh with current status only
    filterUserId = '';
    filterUserIdController.clear();
    fetchOrdersWithFilters(
      status: selectedStatus != 'All' ? selectedStatus : null,
    );
  }

  void applyLocalFilters() {
    if (searchQuery.isEmpty) {
      filteredOrders = List.from(orders);
    } else {
      filteredOrders = orders.where((order) {
        final customerName = order.user?['name']?.toString().toLowerCase() ?? '';
        final customerEmail = order.user?['email']?.toString().toLowerCase() ?? '';
        final orderId = order.id.toLowerCase();
        final searchLower = searchQuery.toLowerCase();
        
        return orderId.contains(searchLower) ||
               customerName.contains(searchLower) ||
               customerEmail.contains(searchLower);
      }).toList();
    }
    notifyListeners();
  }

  void clearFilters() {
    searchQuery = '';
    selectedStatus = 'All';
    filterUserId = '';
    filterUserIdController.clear();
    fetchAllOrders();
  }

  // GET /admin/search/orders - Search orders with query (API)
  Future<List<Order>> searchOrdersApi(String query, {String? status, String? startDate, String? endDate}) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final queryParams = <String, dynamic>{
        'q': query,
      };
      if (status != null && status != 'All') queryParams['status'] = status;
      if (startDate != null) queryParams['startDate'] = startDate;
      if (endDate != null) queryParams['endDate'] = endDate;

      final response = await _dio.get(
        '/admin/search/orders',
        queryParameters: queryParams,
      );

      final List<dynamic> data = response.data;
      final searchResults = data.map((json) => Order.fromJson(json)).toList();
      successMessage = 'Order search completed successfully';
      _scheduleAutoHideMessages();
      return searchResults;
    } on DioException catch (e) {
      if (e.response != null) {
        error = 'Failed to search orders: ${e.response!.statusCode} - ${e.response!.data}';
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

  double get totalRevenue {
    return filteredOrders.fold(0.0, (sum, order) => sum + order.totalAmount);
  }

  int get totalOrders => filteredOrders.length;

  Map<String, int> get ordersByStatus {
    final statusCount = <String, int>{};
    for (final order in filteredOrders) {
      statusCount[order.status] = (statusCount[order.status] ?? 0) + 1;
    }
    return statusCount;
  }

  @override
  void dispose() {
    filterUserIdController.dispose();
    super.dispose();
  }
}