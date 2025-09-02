import 'package:flutter/material.dart';
import 'plumber_drawer.dart';
import '../../constants/colors.dart';

class PlumberDashboardScreen extends StatelessWidget {
  const PlumberDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plumber Dashboard'),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: const PlumberDrawer(),
      body: Container(
        color: AppColors.backgroundColor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeCard(),
              const SizedBox(height: 24),
              _buildQuickActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [AppColors.primaryBlue, AppColors.secondaryBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Icon(Icons.admin_panel_settings, color: Colors.white, size: 48),
            SizedBox(height: 16),
            Text(
              'Welcome, Plumber!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Manage your business efficiently',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.accentBlue, width: 1.2),
      ),
      margin: EdgeInsets.zero,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.9,
              children: [
                _buildActionButton(
                  context,
                  icon: Icons.people,
                  label: 'View Incentives',
                  onPressed: () =>
                      Navigator.pushNamed(context, '/seller/incentives'),
                ),
                _buildActionButton(
                  context,
                  icon: Icons.inventory,
                  label: 'Track Points',
                  onPressed: () =>
                      Navigator.pushNamed(context, '/seller/points'),
                ),
                _buildActionButton(
                  context,
                  icon: Icons.local_shipping,
                  label: 'Post Delivery Report',
                  onPressed: () =>
                      Navigator.pushNamed(context, '/seller/delivery-report'),
                ),
                _buildActionButton(
                  context,
                  icon: Icons.inventory,
                  label: 'Registered Warranty',
                  onPressed: () =>
                      Navigator.pushNamed(context, '/seller/register-warranty'),
                ),
                _buildActionButton(
                  context,
                  icon: Icons.people,
                  label: 'Validate Warranty',
                  onPressed: () =>
                      Navigator.pushNamed(context, '/seller/validate-warranty'),
                ),
                _buildActionButton(
                  context,
                  icon: Icons.inventory,
                  label: 'Commissioned Work',
                  onPressed: () =>
                      Navigator.pushNamed(context, '/seller/commissioned-work'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondaryBlue,
          foregroundColor: AppColors.textPrimary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textLight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
