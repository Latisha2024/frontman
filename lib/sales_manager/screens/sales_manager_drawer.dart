import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class SalesManagerDrawer extends StatelessWidget {
  const SalesManagerDrawer({super.key});

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
                CircleAvatar(radius: 28, backgroundColor: AppColors.secondaryBlue ,child: Icon(Icons.manage_accounts, size: 32, color: Colors.white,),),
                SizedBox(height: 12),
                Text('Sales Manager', style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Sales Manager Dashboard'),
            onTap: () => Navigator.pushNamed(context, '/sales_manager/dashboard'),
          ),
          ListTile(
            leading: const Icon(Icons.gps_fixed),
            title: const Text('Track Field Executive GPS'),
            onTap: () => Navigator.pushNamed(context, '/sales_manager/gps_tracking'),
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('View Performance Reports'),
            onTap: () => Navigator.pushNamed(context, '/sales_manager/performance_reports'),
          ),
          ListTile(
            leading: const Icon(Icons.assignment),
            title: const Text('Assign Tasks'),
            onTap: () => Navigator.pushNamed(context, '/sales_manager/assign_tasks'),
          ),
          ListTile(
            leading: const Icon(Icons.check_circle),
            title: const Text('Approve DVR Reports'),
            onTap: () => Navigator.pushNamed(context, '/sales_manager/approve_dvr_reports'),
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