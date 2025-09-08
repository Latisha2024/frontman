import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../widgets/browsecatalogpage.dart';
import '../widgets/Getcatalogpage.dart';
import '../widgets/Addtocartpage.dart';
import '../widgets/Addpromocode.dart';
import '../widgets/Placeorderpage.dart';
//import '../widgets/createorderpage.dart';
import '../widgets/Trackorderpage.dart';
import '../widgets/Orderhistorypage.dart';
import '../widgets/Orderconfirmationpage.dart';
import 'ManageStockPage.dart';

class DistributorHomePage extends StatelessWidget {
  const DistributorHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Distributor Dashboard"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primary),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.business, size: 32, color: AppColors.primary),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Distributor',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            ExpansionTile(
              leading: const Icon(Icons.shopping_bag),
              title: const Text("Catalog & Orders"),
              children: [
                _drawerItem(context, "Browse Product Catalog", const CategoryPage()),
                _drawerItem(context, "Get Product Catalog", const GetCatalogPage()),
                _drawerItem(context, "Add Products to Cart", const CartPage()),
                _drawerItem(context, "Apply Promo Code", const PromoCodePage()),
                _drawerItem(context, "Place Order", const PlaceOrderPage()),
                // _drawerItem(context, "Create Order", const CreateOrderPage()),
                _drawerItem(context, "Track Order Status", const TrackOrderPage()),
                _drawerItem(context, "View Order History", const OrderHistoryPage()),
                _drawerItem(context, "Receive Order Confirmation", const OrderConfirmationPage()),
              ],
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text("Stock Management"),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StockPage())),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Sign Out"),
              onTap: () => Navigator.pushReplacementNamed(context, '/login'),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Catalog & Orders",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _dashboardButton(context, "Categories", Icons.list, const CategoryPage()),
                  _dashboardButton(context, "Get Catalog", Icons.download, const GetCatalogPage()),
                  _dashboardButton(context, "Add to Cart", Icons.add_shopping_cart, const CartPage()),
                  _dashboardButton(context, "Apply Promo", Icons.percent, const PromoCodePage()),
                  _dashboardButton(context, "Place Order", Icons.check_circle, const PlaceOrderPage()),
                  // _dashboardButton(context, "Create Order", Icons.edit, const CreateOrderPage()),
                  _dashboardButton(context, "Track Order", Icons.track_changes, const TrackOrderPage()),
                  _dashboardButton(context, "Order History", Icons.history, const OrderHistoryPage()),
                  _dashboardButton(context, "Order Confirmation", Icons.mark_email_read, const OrderConfirmationPage()),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text("Stock Management",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: _dashboardButton(context, "Update Stock", Icons.inventory, const StockPage()),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable drawer item
  Widget _drawerItem(BuildContext context, String title, Widget page) {
    return ListTile(
      title: Text(title),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
    );
  }

  // Reusable dashboard button
  Widget _dashboardButton(BuildContext context, String title, IconData icon, Widget page) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
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
