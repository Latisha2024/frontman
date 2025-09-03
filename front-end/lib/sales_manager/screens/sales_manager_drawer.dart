import 'package:flutter/material.dart';
import 'package:role_based_app/sales_manager/screens/sales_manager_dashboard.dart';
import '../../admin/screens/assign_incentive.dart';
import '../../admin/screens/audit_logs.dart';
import '../../admin/screens/convert_points.dart';
import '../../admin/screens/generate_reports.dart';
import '../../admin/screens/manage_products.dart';
import '../../admin/screens/send_notifications.dart';
import '../../admin/screens/warranty_database.dart';
import '../../constants/colors.dart';
 
import '../../admin/screens/manage_users.dart';
import '../../admin/screens/invoices.dart';
import '../../admin/screens/order_summary.dart';
import 'approve_dvr_reports.dart';
import 'assign_tasks.dart';
import 'gps_tracking.dart';

class SalesManagerDrawer extends StatelessWidget {
  const SalesManagerDrawer({super.key});

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
                const CircleAvatar(radius: 28, backgroundColor: AppColors.secondaryBlue ,child: Icon(Icons.manage_accounts, size: 32, color: Colors.white,),),
                const SizedBox(height: 12),
                const Text('Sales Manager', style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Sales Manager Dashboard'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SalesManagerDashboardScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.gps_fixed),
            title: const Text('Track Field Executive GPS'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SalesManagerGpsTrackingScreen(role: "manager",),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.assignment),
            title: const Text('Assign Tasks'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SalesManagerAssignTasksScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.check_circle),
            title: const Text('Approve DVR Reports'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SalesManagerApproveDvrReportsScreen(),
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
                  builder: (context) => ManageUsersScreen(role: "manager"),
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
                  builder: (context) => ManageProductsScreen(role: "manager"),
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
                  builder: (context) => AdminInvoicesScreen(role: "manager"),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.bookmark_border),
            title: const Text('Order Summary'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderSummaryScreen(role: "manager"),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Generate Reports'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GenerateReportsScreen(role: "manager"),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.currency_rupee_outlined),
            title: const Text('Convert Points To Cash'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConvertPointsToCashScreen(role: "manager"),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Send Push Notifications'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SendNotificationsScreen(role: "manager"),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('Manage Warranty Database'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WarrantyDatabaseScreen(role: "manager"),
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
                  builder: (context) => AuditLogsScreen(role: "manager"),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.card_giftcard),
            title: const Text('Assign Incentive'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AssignIncentiveScreen(role: "manager"),
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