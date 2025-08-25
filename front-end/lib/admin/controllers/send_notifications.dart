import 'package:flutter/material.dart';

class AdminSendNotificationsController extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  String? successMessage;
  final titleController = TextEditingController();
  final messageController = TextEditingController();
  final userIdController = TextEditingController();

  void sendNotification() {
    final userId = userIdController.text.trim();
    final title = titleController.text.trim();
    final message = messageController.text.trim();
    if (userId.isEmpty || title.isEmpty || message.isEmpty) {
      error = 'User ID, title and message are required.';
      notifyListeners();
      return;
    }
    isLoading = true;
    error = null;
    successMessage = null;
    notifyListeners();
    isLoading = false;
    successMessage = 'Notification sent to user $userId!';
    notifyListeners();
    clearForm();
  }

  void clearForm() {
    userIdController.clear();
    titleController.clear();
    messageController.clear();
    error = null;
    successMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    userIdController.dispose();
    titleController.dispose();
    messageController.dispose();
    super.dispose();
  }
} 