import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import 'package:role_based_app/field_executive/widgets/AddFollowUpPage.dart';
import 'package:role_based_app/field_executive/widgets/AddProductToOrderPage.dart';
import 'package:role_based_app/field_executive/widgets/AssignedCustomersPage.dart';
import 'package:role_based_app/field_executive/widgets/Camera_Page.dart';
import 'package:role_based_app/field_executive/widgets/CaptureSignaturePage.dart';
import 'package:role_based_app/field_executive/widgets/Chat_Page.dart';
import 'package:role_based_app/field_executive/widgets/CheckStockPage.dart';
import 'package:role_based_app/field_executive/widgets/CustomerVisitReportFormPage.dart';
import 'package:role_based_app/field_executive/widgets/GetProductDetailsPage.dart';
import 'package:role_based_app/field_executive/widgets/PlaceOrderPage.dart';
import 'package:role_based_app/field_executive/widgets/ReceiveNotificationsPage.dart';
import 'package:role_based_app/field_executive/widgets/Status_Page.dart';
import 'package:role_based_app/field_executive/widgets/SubmitDvrPage.dart';
import 'package:role_based_app/field_executive/widgets/SyncOfflineDataPage.dart';
import 'package:role_based_app/field_executive/widgets/Tasks_Page.dart';
import 'package:role_based_app/field_executive/widgets/UpdateStockPage.dart';

class FieldExecutiveUI extends StatelessWidget {
  const FieldExecutiveUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Map<String, dynamic>>> categorizedFeatures = {
      'GPS Tracking': [
        {'title': 'Start Tracking', 'page': const StatusPage(), 'icon': Icons.location_on},
        {'title': 'Status', 'page': const StatusPage(), 'icon': Icons.info_outline},
        {'title': 'Tasks', 'page': const TasksPage(), 'icon': Icons.task},
        {'title': 'Chat', 'page': const ChatPage(), 'icon': Icons.chat},
        {'title': 'Camera', 'page': const CameraPage(), 'icon': Icons.camera_alt},
      ],
      'Customer Visits': [
        {'title': 'Assigned Customers', 'page': const AssignedCustomersPage(), 'icon': Icons.people_outline},
        {'title': 'Visit Customer', 'page': const CustomerVisitReportFormPage(), 'icon': Icons.location_searching},
        {'title': 'Submit DVR', 'page': const SubmitDvrPage(), 'icon': Icons.upload},
        {'title': 'Add Follow Up', 'page': const AddFollowUpPage(), 'icon': Icons.add_alert},
      ],
      'Order Management': [
        {'title': 'Place Order', 'page': const PlaceOrderPage(), 'icon': Icons.shopping_cart},
        {'title': 'Get Product Details', 'page': const GetProductDetailsPage(), 'icon': Icons.info},
        {'title': 'Check Stock', 'page': const CheckStockPage(), 'icon': Icons.inventory},
        {'title': 'Add Product to Order', 'page': const AddProductToOrderPage(), 'icon': Icons.add_shopping_cart},
        {'title': 'Update Stock', 'page': const UpdateStockPage(), 'icon': Icons.update},
      ],
      'Other Operations': [
        {'title': 'Capture Signature', 'page': const CaptureSignaturePage(), 'icon': Icons.edit_document},
        {'title': 'Sync Offline Data', 'page': const SyncOfflinePage(), 'icon': Icons.sync},
        {'title': 'Receive Notifications', 'page': const NotificationsPage(), 'icon': Icons.notifications},
      ],
    };

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        title: const Text('Executive Dashboard'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primaryBlue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12),
                  CircleAvatar(
                    radius: 28,
                    child: Icon(Icons.badge, size: 32),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Field Executive',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            for (var category in categorizedFeatures.keys)
              ListTile(
                leading: const Icon(Icons.folder_copy_outlined),
                title: Text(category),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FeatureCategoryPage(
                        title: category,
                        features: categorizedFeatures[category]!,
                      ),
                    ),
                  );
                },
              ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: () => Navigator.pushReplacementNamed(context, '/login'),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.grey.shade100,
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: categorizedFeatures.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    entry.key,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.3,
                  children: entry.value.map((feature) {
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => feature['page']),
                      ),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(feature['icon'], size: 32, color: AppColors.primaryBlue),
                              const SizedBox(height: 8),
                              Text(
                                feature['title'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class FeatureCategoryPage extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> features;

  const FeatureCategoryPage({required this.title, required this.features, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        title: Text(title),
      ),
      body: Container(
        color: Colors.grey.shade100,
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.3,
          children: features.map((feature) {
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => feature['page']),
              ),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(feature['icon'], size: 32, color: AppColors.primaryBlue),
                      const SizedBox(height: 8),
                      Text(
                        feature['title'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
