import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../authpage/pages/auth_services.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final dio = Dio(BaseOptions(baseUrl: "https://frontman-1.onrender.com"));
  List<dynamic> notifications = [];
  bool loading = true;
  bool unreadOnly = false;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final authService = AuthService();
      final token = await authService.getToken();

      final response = await dio.get(
        '/fieldExecutive/operations/notifications',
        queryParameters: {'unreadOnly': unreadOnly.toString()},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        setState(() => notifications = response.data);
      } else {
        setState(() => error = "Failed to fetch notifications (${response.statusCode})");
      }
    } catch (e) {
      setState(() => error = "Error fetching notifications: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      final authService = AuthService();
      final token = await authService.getToken();

      await dio.patch(
        '/fieldExecutive/operations/notifications/$id/read',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // Update UI locally
      setState(() {
        final index = notifications.indexWhere((n) => n['id'] == id);
        if (index != -1) notifications[index]['isRead'] = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to mark as read: $e")),
      );
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final authService = AuthService();
      final token = await authService.getToken();

      await dio.patch(
        '/fieldExecutive/operations/notifications/read-all',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      setState(() {
        for (var n in notifications) {
          n['isRead'] = true;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to mark all as read: $e")),
      );
    }
  }

  Widget buildNotificationItem(Map<String, dynamic> notif) {
    final isRead = notif['isRead'] ?? false;
    final createdAt = DateTime.tryParse(notif['createdAt'] ?? '');
    final formattedDate = createdAt != null
        ? "${createdAt.day}/${createdAt.month}/${createdAt.year} ${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}"
        : '';

    return Card(
      color: isRead ? Colors.white : Colors.blue.shade50,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: ListTile(
        leading: Icon(
          isRead ? Icons.notifications_none : Icons.notifications_active,
          color: isRead ? Colors.grey : Colors.blueAccent,
        ),
        title: Text(
          notif['type'] ?? 'Notification',
          style: TextStyle(
            fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notif['message'] ?? ''),
            if (formattedDate.isNotEmpty)
              Text(formattedDate, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        trailing: !isRead
            ? IconButton(
                icon: const Icon(Icons.mark_email_read, color: Colors.green),
                onPressed: () => markAsRead(notif['id']),
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notifications"),
        actions: [
          IconButton(
            icon: Icon(unreadOnly ? Icons.mark_email_unread : Icons.mail),
            tooltip: unreadOnly ? "Show All" : "Show Unread Only",
            onPressed: () {
              setState(() => unreadOnly = !unreadOnly);
              fetchNotifications();
            },
          ),
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: "Mark All as Read",
            onPressed: markAllAsRead,
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!, style: const TextStyle(color: Colors.red)))
              : RefreshIndicator(
                  onRefresh: fetchNotifications,
                  child: notifications.isEmpty
                      ? const Center(child: Text("No notifications found"))
                      : ListView.builder(
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            return buildNotificationItem(notifications[index]);
                          },
                        ),
                ),
    );
  }
}
