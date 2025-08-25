import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants/colors.dart'; // Ensure AppColors.primary and AppColors.inputFill are defined

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final userIdController = TextEditingController(text: '101');
  List<String> notifications = [];
  String statusMessage = '';
  Color statusColor = Colors.green;

  Future<void> fetchNotifications() async {
    final userId = int.tryParse(userIdController.text);

    if (userId == null) {
      setState(() {
        statusMessage = "❗ Invalid User ID";
        statusColor = Colors.red;
        notifications = [];
      });
      return;
    }

    try {
      // Simulated placeholder response
      await Future.delayed(const Duration(seconds: 1)); // Simulate loading
      final fetched = [
        "🔔 New order assigned to you.",
        "📦 Product XYZ is low on stock.",
        "✅ Payment for order #123 confirmed.",
        "📝 Meeting scheduled with client ABC.",
        "📍 Location update required for today's visit.",
        "📄 Document approval pending from manager.",
        "📊 Monthly performance report available."
      ];

      setState(() {
        notifications = fetched;
        statusMessage = "✅ Placeholder notifications loaded.";
        statusColor = Colors.green;
      });

      // Uncomment for real API call
      /*
      final response = await http.post(
        Uri.parse("https://yourapi.com/api/notifications"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"userId": userId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final fetched = data["notifications"];

        setState(() {
          notifications = List<String>.from(fetched ?? []);
          statusMessage = "✅ Notifications loaded!";
          statusColor = Colors.green;
        });
      } else {
        setState(() {
          statusMessage = "❌ Failed (Status: ${response.statusCode})";
          statusColor = Colors.red;
          notifications = [];
        });
      }
      */
    } catch (e) {
      setState(() {
        statusMessage = "⚠️ Error: ${e.toString()}";
        statusColor = Colors.red;
        notifications = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Notifications", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Check Notifications",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: userIdController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "User ID",
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: AppColors.inputFill,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: fetchNotifications,
                    icon: const Icon(Icons.refresh),
                    label: const Text("Get Notifications"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (statusMessage.isNotEmpty)
                  Text(
                    statusMessage,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                const SizedBox(height: 10),
                const Divider(thickness: 1),
                const SizedBox(height: 10),
                Expanded(
                  child: notifications.isEmpty
                      ? const Center(
                          child: Text(
                            "No notifications to show.",
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        )
                      : ListView.builder(
                          itemCount: notifications.length,
                          itemBuilder: (_, i) => Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              leading: const Icon(Icons.notifications, color: Colors.orangeAccent),
                              title: Text(notifications[i]),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
