import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import 'package:role_based_app/field_executive/widgets/tasks_page.dart';
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
import 'package:role_based_app/field_executive/widgets/location.dart';
import 'package:role_based_app/field_executive/widgets/SubmitDvrPage.dart';
import 'package:role_based_app/field_executive/widgets/SyncOfflineDataPage.dart';
import 'package:role_based_app/field_executive/widgets/UpdateStockPage.dart';

class FieldExecutiveUI extends StatelessWidget {
  const FieldExecutiveUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Field Executive Dashboard"),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
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
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.badge, size: 32, color: AppColors.primaryBlue),
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

            // Section 1: GPS & Communication
            ExpansionTile(
              leading: const Icon(Icons.location_on),
              title: const Text("GPS & Communication"),
              children: [
                _drawerItem(context, "Start Tracking", const UpdateLocationPage()),
                _drawerItem(context, "Tasks", const AddTaskPage()),
                _drawerItem(context, "Chat", const ChatPage()),
                _drawerItem(context, "Camera", const CameraPage()),
              ],
            ),

            // Section 2: Customer Visits
            ExpansionTile(
              leading: const Icon(Icons.people_alt_outlined),
              title: const Text("Customer Visits"),
              children: [
                _drawerItem(context, "Assigned Customers", const FieldExecutiveCustomersPage()),
                _drawerItem(context, "Visit Customer", const CustomerVisitPage()),
                _drawerItem(context, "Submit DVR", const DVRPage()),
                _drawerItem(context, "Add Follow Up", const AddFollowUpPage()),
              ],
            ),

            // Section 3: Order Management
            ExpansionTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text("Order Management"),
              children: [
                _drawerItem(context, "Place Order", const FieldExecutivePlaceOrderPage()),
                _drawerItem(context, "Get Product Details", const MyOrdersPage()),
                _drawerItem(context, "Check Stock", const StockPage()),
                _drawerItem(context, "Add Product to Order", const AddProductToOrderPage()),
                _drawerItem(context, "Update Stock", const UpdateStockPage()),
              ],
            ),

            // Section 4: Other Operations
            ExpansionTile(
              leading: const Icon(Icons.settings_applications),
              title: const Text("Other Operations"),
              children: [
                _drawerItem(context, "Capture Signature", const CaptureSignaturePage()),
                _drawerItem(context, "Sync Offline Data", const SyncOfflineDataPage()),
                _drawerItem(context, "Receive Notifications", const NotificationsPage()),
              ],
            ),

            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Sign Out"),
              onTap: () => Navigator.pushReplacementNamed(context, '/login'),
            ),
          ],
        ),
      ),

      // -------- Dashboard Body --------
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _sectionTitle("GPS & Communication"),
            _gridSection(context, [
              _dashboardButton(context, "Start Tracking", Icons.location_on, const UpdateLocationPage()),
              _dashboardButton(context, "Tasks", Icons.task, const AddTaskPage()),
              _dashboardButton(context, "Chat", Icons.chat, const ChatPage()),
              _dashboardButton(context, "Camera", Icons.camera_alt, const CameraPage()),
            ]),

            const SizedBox(height: 16),
            _sectionTitle("Customer Visits"),
            _gridSection(context, [
              _dashboardButton(context, "Assigned Customers", Icons.people_outline, const FieldExecutiveCustomersPage()),
              _dashboardButton(context, "Visit Customer", Icons.location_searching, const CustomerVisitPage()),
              _dashboardButton(context, "Submit DVR", Icons.upload, const DVRPage()),
              _dashboardButton(context, "Add Follow Up", Icons.add_alert, const AddFollowUpPage()),
            ]),

            const SizedBox(height: 16),
            _sectionTitle("Order Management"),
            _gridSection(context, [
              _dashboardButton(context, "Place Order", Icons.shopping_cart, const FieldExecutivePlaceOrderPage()),
              _dashboardButton(context, "Product Details", Icons.info, const MyOrdersPage()),
              _dashboardButton(context, "Check Stock", Icons.inventory, const StockPage()),
              _dashboardButton(context, "Add to Order", Icons.add_shopping_cart, const AddProductToOrderPage()),
              _dashboardButton(context, "Update Stock", Icons.update, const UpdateStockPage()),
            ]),

            const SizedBox(height: 16),
            _sectionTitle("Other Operations"),
            _gridSection(context, [
              _dashboardButton(context, "Capture Signature", Icons.edit_document, const CaptureSignaturePage()),
              _dashboardButton(context, "Sync Offline Data", Icons.sync, const SyncOfflineDataPage()),
              _dashboardButton(context, "Notifications", Icons.notifications, const NotificationsPage()),
            ]),
          ],
        ),
      ),
    );
  }

  // ----------------- Helper Widgets -----------------

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _drawerItem(BuildContext context, String title, Widget page) {
    return ListTile(
      title: Text(title),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
    );
  }

  Widget _gridSection(BuildContext context, List<Widget> children) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: children,
    );
  }

  Widget _dashboardButton(BuildContext context, String title, IconData icon, Widget page) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32),
          const SizedBox(height: 8),
          Text(title, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

