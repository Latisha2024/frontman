// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// // import '../../constants/colors.dart'; // Ensure AppColors.primary and AppColors.inputFill are defined

// // class NotificationsPage extends StatefulWidget {
// //   const NotificationsPage({super.key});

// //   @override
// //   State<NotificationsPage> createState() => _NotificationsPageState();
// // }

// // class _NotificationsPageState extends State<NotificationsPage> {
// //   final userIdController = TextEditingController(text: '101');
// //   List<String> notifications = [];
// //   String statusMessage = '';
// //   Color statusColor = Colors.green;

// //   Future<void> fetchNotifications() async {
// //     final userId = int.tryParse(userIdController.text);

// //     if (userId == null) {
// //       setState(() {
// //         statusMessage = "❗ Invalid User ID";
// //         statusColor = Colors.red;
// //         notifications = [];
// //       });
// //       return;
// //     }

// //     try {
// //       // Simulated placeholder response
// //       await Future.delayed(const Duration(seconds: 1)); // Simulate loading
// //       final fetched = [
// //         "🔔 New order assigned to you.",
// //         "📦 Product XYZ is low on stock.",
// //         "✅ Payment for order #123 confirmed.",
// //         "📝 Meeting scheduled with client ABC.",
// //         "📍 Location update required for today's visit.",
// //         "📄 Document approval pending from manager.",
// //         "📊 Monthly performance report available."
// //       ];

// //       setState(() {
// //         notifications = fetched;
// //         statusMessage = "✅ Placeholder notifications loaded.";
// //         statusColor = Colors.green;
// //       });

// //       // Uncomment for real API call
// //       /*
// //       final response = await http.post(
// //         Uri.parse("https://yourapi.com/api/notifications"),
// //         headers: {'Content-Type': 'application/json'},
// //         body: jsonEncode({"userId": userId}),
// //       );

// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(response.body);
// //         final fetched = data["notifications"];

// //         setState(() {
// //           notifications = List<String>.from(fetched ?? []);
// //           statusMessage = "✅ Notifications loaded!";
// //           statusColor = Colors.green;
// //         });
// //       } else {
// //         setState(() {
// //           statusMessage = "❌ Failed (Status: ${response.statusCode})";
// //           statusColor = Colors.red;
// //           notifications = [];
// //         });
// //       }
// //       */
// //     } catch (e) {
// //       setState(() {
// //         statusMessage = "⚠️ Error: ${e.toString()}";
// //         statusColor = Colors.red;
// //         notifications = [];
// //       });
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.grey.shade100,
// //       appBar: AppBar(
// //         title: const Text("Notifications", style: TextStyle(fontWeight: FontWeight.bold)),
// //         backgroundColor: AppColors.primary,
// //         foregroundColor: Colors.white,
// //         elevation: 3,
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Card(
// //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// //           elevation: 4,
// //           child: Padding(
// //             padding: const EdgeInsets.all(20),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 const Text(
// //                   "Check Notifications",
// //                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //                 ),
// //                 const SizedBox(height: 16),
// //                 TextField(
// //                   controller: userIdController,
// //                   keyboardType: TextInputType.number,
// //                   decoration: InputDecoration(
// //                     labelText: "User ID",
// //                     prefixIcon: const Icon(Icons.person),
// //                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
// //                     filled: true,
// //                     fillColor: AppColors.inputFill,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 16),
// //                 SizedBox(
// //                   width: double.infinity,
// //                   child: ElevatedButton.icon(
// //                     onPressed: fetchNotifications,
// //                     icon: const Icon(Icons.refresh),
// //                     label: const Text("Get Notifications"),
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: AppColors.primary,
// //                       padding: const EdgeInsets.symmetric(vertical: 14),
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(10),
// //                       ),
// //                       textStyle: const TextStyle(fontSize: 16),
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 16),
// //                 if (statusMessage.isNotEmpty)
// //                   Text(
// //                     statusMessage,
// //                     style: TextStyle(
// //                       color: statusColor,
// //                       fontWeight: FontWeight.w600,
// //                       fontSize: 14,
// //                     ),
// //                   ),
// //                 const SizedBox(height: 10),
// //                 const Divider(thickness: 1),
// //                 const SizedBox(height: 10),
// //                 Expanded(
// //                   child: notifications.isEmpty
// //                       ? const Center(
// //                           child: Text(
// //                             "No notifications to show.",
// //                             style: TextStyle(fontStyle: FontStyle.italic),
// //                           ),
// //                         )
// //                       : ListView.builder(
// //                           itemCount: notifications.length,
// //                           itemBuilder: (_, i) => Card(
// //                             shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(12),
// //                             ),
// //                             margin: const EdgeInsets.symmetric(vertical: 6),
// //                             child: ListTile(
// //                               leading: const Icon(Icons.notifications, color: Colors.orangeAccent),
// //                               title: Text(notifications[i]),
// //                             ),
// //                           ),
// //                         ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import '../../authpage/pages/auth_services.dart';

// class NotificationsPage extends StatefulWidget {
//   const NotificationsPage({super.key});

//   @override
//   State<NotificationsPage> createState() => _NotificationsPageState();
// }

// class _NotificationsPageState extends State<NotificationsPage> {
//   final dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:5001")); // Change to deployed backend URL
//   List<dynamic> notifications = [];
//   bool loading = false;
//   bool unreadOnly = false;

//   Future<String?> _getToken() async {
//     final authService = AuthService();
//     return await authService.getToken();
//   }

//   Future<void> fetchNotifications() async {
//     setState(() => loading = true);
//     try {
//       final token = await _getToken();
//       if (token == null) return;

//       final response = await dio.get(
//         '/fieldExecutive/operations/notifications',
//         queryParameters: {'unreadOnly': unreadOnly},
//         options: Options(headers: {'Authorization': 'Bearer $token'}),
//       );

//       setState(() {
//         notifications = response.data;
//       });
//     } catch (e) {
//       print("Error fetching notifications: $e");
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   Future<void> markAsRead(String id) async {
//     try {
//       final token = await _getToken();
//       if (token == null) return;

//       await dio.patch(
//         '/fieldExecutive/operations/notifications/$id/read',
//         options: Options(headers: {'Authorization': 'Bearer $token'}),
//       );

//       setState(() {
//         notifications = notifications.map((n) {
//           if (n['id'] == id) n['isRead'] = true;
//           return n;
//         }).toList();
//       });
//     } catch (e) {
//       print("Error marking notification as read: $e");
//     }
//   }

//   Future<void> markAllAsRead() async {
//     try {
//       final token = await _getToken();
//       if (token == null) return;

//       await dio.patch(
//         '/fieldExecutive/operations/notifications/read-all',
//         options: Options(headers: {'Authorization': 'Bearer $token'}),
//       );

//       setState(() {
//         notifications = notifications.map((n) {
//           n['isRead'] = true;
//           return n;
//         }).toList();
//       });
//     } catch (e) {
//       print("Error marking all notifications as read: $e");
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchNotifications();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Notifications"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.mark_email_read),
//             tooltip: "Mark All Read",
//             onPressed: markAllAsRead,
//           ),
//           IconButton(
//             icon: Icon(unreadOnly ? Icons.filter_alt : Icons.filter_alt_outlined),
//             tooltip: "Toggle Unread Only",
//             onPressed: () {
//               setState(() => unreadOnly = !unreadOnly);
//               fetchNotifications();
//             },
//           ),
//         ],
//       ),
//       body: loading
//           ? const Center(child: CircularProgressIndicator())
//           : notifications.isEmpty
//               ? const Center(child: Text("No notifications"))
//               : ListView.builder(
//                   itemCount: notifications.length,
//                   itemBuilder: (context, index) {
//                     final n = notifications[index];
//                     return ListTile(
//                       leading: Icon(
//                         n['isRead'] ? Icons.notifications_none : Icons.notifications_active,
//                         color: n['isRead'] ? Colors.grey : Colors.blue,
//                       ),
//                       title: Text(n['message']),
//                       subtitle: Text(n['type']),
//                       trailing: n['isRead']
//                           ? null
//                           : TextButton(
//                               child: const Text("Mark Read"),
//                               onPressed: () => markAsRead(n['id']),
//                             ),
//                     );
//                   },
//                 ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../authpage/pages/auth_services.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:5001"));
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
