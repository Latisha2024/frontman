import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class WorkerDrawer extends StatelessWidget {
  const WorkerDrawer({super.key});

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
                CircleAvatar(radius: 28, backgroundColor: AppColors.secondaryBlue ,child: Icon(Icons.person, size: 32, color: Colors.white,),),
                SizedBox(height: 12),
                Text('Worker', style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Worker Dashboard'),
            onTap: () => Navigator.pushNamed(context, '/worker/dashboard'),
          ),
          ListTile(
            leading: const Icon(Icons.add_box),
            title: const Text('Enter Production Data'),
            onTap: () => Navigator.pushNamed(context, '/worker/production'),
          ),
          ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: const Text('Manage Stock'),
            onTap: () => Navigator.pushNamed(context, '/worker/manage-stock'),
          ),
          ListTile(
            leading: const Icon(Icons.report_problem),
            title: const Text('Report Damaged Stock'),
            onTap: () =>
                Navigator.pushNamed(context, '/worker/report-damage'),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Shift Alerts'),
            onTap: () => Navigator.pushNamed(context, '/worker/shift-alerts'),
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