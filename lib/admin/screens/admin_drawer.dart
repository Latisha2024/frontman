import 'package:flutter/material.dart';
import '../../../constants/colors.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: AppColors.primaryBlue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12),
                CircleAvatar(radius: 28, backgroundColor: AppColors.secondaryBlue ,child: Icon(Icons.admin_panel_settings, size: 32, color: Colors.white,),),
                SizedBox(height: 12),
                Text('Admin', style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Admin Dashboard'),
            onTap: () => Navigator.pushNamed(context, '/admin/dashboard'),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Manage Users'),
            onTap: () => Navigator.pushNamed(context, '/admin/manage-users'),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Manage Products'),
            onTap: () =>
                Navigator.pushNamed(context, '/admin/manage-products'),
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: const Text('Invoices'),
            onTap: () => Navigator.pushNamed(context, '/admin/invoices'),
          ),
          ListTile(
            leading: const Icon(Icons.bookmark_border),
            title: const Text('Order Summary'),
            onTap: () => Navigator.pushNamed(context, '/admin/order-summary'),
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Generate Reports'),
            onTap: () => Navigator.pushNamed(context, '/admin/generate-reports'),
          ),
          ListTile(
            leading: const Icon(Icons.currency_rupee_outlined),
            title: const Text('Convert Points To Cash'),
            onTap: () =>
                Navigator.pushNamed(context, '/admin/convert-points-to-cash'),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Send Push Notifications'),
            onTap: () => Navigator.pushNamed(context, '/admin/send-notifications'),
          ),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('Manage Warranty Database'),
            onTap: () => Navigator.pushNamed(context, '/admin/warranty-database'),
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Audit Logs'),
            onTap: () => Navigator.pushNamed(context, '/admin/audit-logs'),
          ),
          ListTile(
            leading: const Icon(Icons.card_giftcard),
            title: const Text('Assign Incentive'),
            onTap: () => Navigator.pushNamed(context, '/admin/assign-incentive'),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: () => Navigator.pushReplacementNamed(context, '/login'),
          ),
        ],
      ),
    );
  }
}