import 'package:flutter/material.dart';

// Import the navigation target pages
import '../widgets/CaptureSignaturePage.dart';
import '../widgets/SyncOfflineDataPage.dart';
import '../widgets/ReceiveNotificationsPage.dart';

class OtherOperationsPage extends StatelessWidget {
  const OtherOperationsPage({super.key});

  Widget buildActionCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 6,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 36, color: const Color(0xFFA5C8D0)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(description, style: const TextStyle(fontSize: 14, color: Colors.black54)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6F8),
      appBar: AppBar(
        title: const Text("Other Operations", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFA5C8D0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildActionCard(
                    icon: Icons.draw,
                    title: "Capture Signature",
                    description: "Send customer signature to /api/orders/signature",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CaptureSignaturePage()),
                      );
                    },
                  ),
                  buildActionCard(
                    icon: Icons.sync_alt,
                    title: "Sync Offline Data",
                    description: "Sync offline data with /api/field-executive/sync-offline",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SyncOfflinePage(),)
                      );
                    },
                  ),
                  buildActionCard(
                    icon: Icons.notifications_active,
                    title: "Receive Notifications",
                    description: "Get notifications from /api/notifications",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const NotificationsPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.black12)),
              color: Color(0xFFEFF6F8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Icon(Icons.menu, size: 30, color: Color(0xFFA5C8D0)),
                Icon(Icons.arrow_back, size: 30, color: Color(0xFFA5C8D0)),
                Icon(Icons.settings, size: 30, color: Color(0xFFA5C8D0)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
