import 'package:flutter/material.dart';
import 'package:role_based_app/admin/screens/invoices.dart';
import 'package:role_based_app/admin/screens/send_notifications.dart';
import 'package:role_based_app/admin/screens/shift_alerts.dart';
import 'package:role_based_app/admin/screens/stock_management.dart';
import 'package:role_based_app/admin/screens/warranty_database.dart';
import '../../constants/colors.dart';
import '../../sales_manager/screens/gps_tracking.dart';
import 'admin_dashboard.dart';
import 'assign_incentive.dart';
import 'audit_logs.dart';
import 'convert_points.dart';
import 'manage_products.dart';
import 'generate_reports.dart';
import 'manage_users.dart';
import 'order_summary.dart';
import 'company_selection.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primaryBlue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                const CircleAvatar(
                  radius: 28, 
                  backgroundColor: AppColors.secondaryBlue,
                  child: Icon(Icons.admin_panel_settings, size: 32, color: Colors.white),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Admin', 
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 18, 
                    color: Colors.white
                  )
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminDashboardScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Manage Users'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ManageUsersScreen(role: "admin"),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Manage Products'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ManageProductsScreen(role: "admin"),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: const Text('Invoices'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminInvoicesScreen(role: "admin"),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.bookmark_border),
            title: const Text('Orders'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderSummaryScreen(role: "admin"),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Reports'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GenerateReportsScreen(role: "admin"),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.currency_rupee_outlined),
            title: const Text('Points'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConvertPointsToCashScreen(role: "admin"),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SendNotificationsScreen(role: "admin"),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.crisis_alert_sharp),
            title: const Text('Shift Alerts'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShiftAlertsScreen(role: "admin"),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('Manage Stocks'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StockManagementScreen(role: "admin"),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('Warranty'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WarrantyDatabaseScreen(role: "admin"),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Audit Logs'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AuditLogsScreen(role: "admin"),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.card_membership),
            title: const Text('Incentives'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AssignIncentiveScreen(role: "admin"),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.gps_fixed),
            title: const Text('Location'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SalesManagerGpsTrackingScreen(role: "admin"),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.arrow_back),
            title: const Text('Select Company'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CompanySelectionScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: () {
              Navigator.pushNamed(
                context, "/login"
              );
            },
          ),
        ],
      ),
    );
  }
}