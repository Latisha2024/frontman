import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationModel {
  final String id;
  final String type;
  final String message;
  final String? userId;
  final bool read;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationModel({
    required this.id,
    required this.type,
    required this.message,
    this.userId,
    required this.read,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      type: json['type'],
      message: json['message'],
      userId: json['userId'],
      read: json['read'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  NotificationModel copyWith({bool? read}) {
    return NotificationModel(
      id: id,
      type: type,
      message: message,
      userId: userId,
      read: read ?? this.read,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

class AdminSendNotificationsController extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  String? successMessage;
  final titleController = TextEditingController();
  final messageController = TextEditingController();
  final userIdController = TextEditingController();
  late final Dio _dio;

  List<NotificationModel> notifications = [];
  List<NotificationModel> filteredNotifications = [];
  String selectedFilter = 'All'; // All, Read, Unread
  String searchQuery = '';
  String selectedNotificationType = 'info';

  final List<String> notificationTypes = [
    'info',
    'warning',
    'error',
    'success',
    'promotion',
    'system',
    'reminder'
  ];

  static const String baseUrl = 'http://10.0.2.2:5000';

  AdminSendNotificationsController() {
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
    fetchNotifications();
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

  Future<void> fetchNotifications({bool unreadOnly = false}) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      Map<String, dynamic> queryParams = {};
      if (unreadOnly) {
        queryParams['unreadOnly'] = 'true';
      }

      final response = await _dio.get(
        '/admin/notifications',
        queryParameters: queryParams,
      );

      final List<dynamic> data = response.data;
      notifications = data.map((json) => NotificationModel.fromJson(json)).toList();
      applyFilters();
      successMessage = 'Notifications loaded successfully';
      _scheduleAutoHideMessages();
    } on DioException catch (e) {
      if (e.response != null) {
        error = 'Failed to fetch notifications: ${e.response!.statusCode} - ${e.response!.data}';
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

  Future<void> sendNotification() async {
    final userId = userIdController.text.trim();
    final title = titleController.text.trim();
    final message = messageController.text.trim();
    
    if (message.isEmpty) {
      error = 'Message is required';
      notifyListeners();
      _scheduleAutoHideMessages();
      return;
    }

    try {
      isLoading = true;
      error = null;
      successMessage = null;
      notifyListeners();

      final requestBody = {
        'type': selectedNotificationType,
        'message': message,
        'userId': userId.isEmpty ? null : userId,
      };

      final response = await _dio.post(
        '/admin/notifications',
        data: requestBody,
      );

      final responseData = response.data;
      successMessage = responseData['message'] ?? 'Notification sent successfully!';
      clearForm();
      await fetchNotifications(); // Refresh the list
      _scheduleAutoHideMessages();
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        error = responseData['message'] ?? 'Failed to send notification: ${e.response!.statusCode}';
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

  Future<void> markAsRead(String notificationId) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _dio.put(
        '/admin/notifications/$notificationId/read',
      );

      // Update local notification
      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        notifications[index] = notifications[index].copyWith(read: true);
        applyFilters();
      }
      successMessage = 'Notification marked as read';
      _scheduleAutoHideMessages();
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        error = responseData['message'] ?? 'Failed to mark notification as read: ${e.response!.statusCode}';
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

  Future<void> markAllAsRead() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _dio.put(
        '/admin/notifications/read-all',
      );

      // Update all local notifications to read
      notifications = notifications.map((n) => n.copyWith(read: true)).toList();
      applyFilters();
      successMessage = 'All notifications marked as read';
      _scheduleAutoHideMessages();
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        error = responseData['message'] ?? 'Failed to mark all notifications as read: ${e.response!.statusCode}';
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

  void searchNotifications(String query) {
    searchQuery = query;
    applyFilters();
  }

  void filterNotifications(String filter) {
    selectedFilter = filter;
    applyFilters();
  }

  void applyFilters() {
    filteredNotifications = notifications.where((notification) {
      bool matchesSearch = searchQuery.isEmpty ||
          notification.message.toLowerCase().contains(searchQuery.toLowerCase()) ||
          notification.type.toLowerCase().contains(searchQuery.toLowerCase());

      bool matchesFilter = selectedFilter == 'All' ||
          (selectedFilter == 'Read' && notification.read) ||
          (selectedFilter == 'Unread' && !notification.read);

      return matchesSearch && matchesFilter;
    }).toList();

    // Sort by creation date (newest first)
    filteredNotifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }

  void setNotificationType(String type) {
    selectedNotificationType = type;
    notifyListeners();
  }

  void clearForm() {
    userIdController.clear();
    titleController.clear();
    messageController.clear();
    selectedNotificationType = 'info';
    error = null;
    successMessage = null;
    notifyListeners();
    _scheduleAutoHideMessages();
  }

  void clearMessages() {
    error = null;
    successMessage = null;
    notifyListeners();
  }

  int get unreadCount => notifications.where((n) => !n.read).length;

  @override
  void dispose() {
    userIdController.dispose();
    titleController.dispose();
    messageController.dispose();
    super.dispose();
  }
} 