import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

class SellerDrawer extends StatelessWidget {
  const SellerDrawer({super.key});

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
                CircleAvatar(radius: 28, child: Icon(Icons.person, size: 32)),
                SizedBox(height: 12),
                Text('Plumber',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Plumber Dashboard'),
            onTap: () => Navigator.pushNamed(context, '/seller/dashboard'),
          ),
          ListTile(
            leading: const Icon(Icons.card_giftcard),
            title: const Text('View Incentives'),
            onTap: () => Navigator.pushNamed(context, '/seller/incentives'),
          ),
          ListTile(
            leading: const Icon(Icons.stars),
            title: const Text('Track Points'),
            onTap: () => Navigator.pushNamed(context, '/seller/points'),
          ),
          ListTile(
            leading: const Icon(Icons.local_shipping),
            title: const Text('Post Delivery Report'),
            onTap: () =>
                Navigator.pushNamed(context, '/seller/delivery-report'),
          ),
          ListTile(
            leading: const Icon(Icons.assignment_turned_in),
            title: const Text('Register Warranty'),
            onTap: () =>
                Navigator.pushNamed(context, '/seller/register-warranty'),
          ),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('Validate Warranty'),
            onTap: () =>
                Navigator.pushNamed(context, '/seller/validate-warranty'),
          ),
          ListTile(
            leading: const Icon(Icons.work),
            title: const Text('Commissioned Work'),
            onTap: () =>
                Navigator.pushNamed(context, '/seller/commissioned-work'),
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
