// // import 'package:flutter/material.dart';
// // import '../../constants/colors.dart';
// // import '../widgets/browsecatalogpage.dart';
// // import '../widgets/Getcatalogpage.dart';
// // import '../widgets/Addtocartpage.dart';
// // import '../widgets/Addpromocode.dart';
// // import '../widgets/Placeorderpage.dart';
// // //import '../widgets/createorderpage.dart';
// // import '../widgets/Trackorderpage.dart';
// // import '../widgets/Orderhistorypage.dart';
// // import '../widgets/Orderconfirmationpage.dart';
// // import 'ManageStockPage.dart';

// // class DistributorHomePage extends StatelessWidget {
// //   const DistributorHomePage({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       appBar: AppBar(
// //         title: const Text("Distributor Dashboard"),
// //         backgroundColor: AppColors.primary,
// //         foregroundColor: Colors.white,
// //       ),
// //       drawer: Drawer(
// //         child: ListView(
// //           padding: EdgeInsets.zero,
// //           children: [
// //             const DrawerHeader(
// //               decoration: BoxDecoration(color: AppColors.primary),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   CircleAvatar(
// //                     radius: 28,
// //                     backgroundColor: Colors.white,
// //                     child: Icon(Icons.business, size: 32, color: AppColors.primary),
// //                   ),
// //                   SizedBox(height: 12),
// //                   Text(
// //                     'Distributor',
// //                     style: TextStyle(
// //                       fontWeight: FontWeight.bold,
// //                       fontSize: 18,
// //                       color: Colors.white,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             ExpansionTile(
// //               leading: const Icon(Icons.shopping_bag),
// //               title: const Text("Catalog & Orders"),
// //               children: [
// //                 _drawerItem(context, "Browse Product Catalog", const CategoryPage()),
// //                 _drawerItem(context, "Get Product Catalog", const GetCatalogPage()),
// //                 _drawerItem(context, "Add Products to Cart", const CartPage()),
// //                 _drawerItem(context, "Apply Promo Code", const PromoCodePage()),
// //                 _drawerItem(context, "Place Order", const PlaceOrderPage()),
// //                 // _drawerItem(context, "Create Order", const CreateOrderPage()),
// //                 _drawerItem(context, "Track Order Status", const TrackOrderPage()),
// //                 _drawerItem(context, "View Order History", const OrderHistoryPage()),
// //                 _drawerItem(context, "Receive Order Confirmation", const OrderConfirmationPage()),
// //               ],
// //             ),
// //             const Divider(),
// //             ListTile(
// //               leading: const Icon(Icons.inventory),
// //               title: const Text("Stock Management"),
// //               onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StockPage())),
// //             ),
// //             ListTile(
// //               leading: const Icon(Icons.logout),
// //               title: const Text("Sign Out"),
// //               onTap: () => Navigator.pushReplacementNamed(context, '/login'),
// //             ),
// //           ],
// //         ),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             const Text("Catalog & Orders",
// //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// //             const SizedBox(height: 12),
// //             Expanded(
// //               child: GridView.count(
// //                 crossAxisCount: 2,
// //                 crossAxisSpacing: 12,
// //                 mainAxisSpacing: 12,
// //                 children: [
// //                   _dashboardButton(context, "Categories", Icons.list, const CategoryPage()),
// //                   _dashboardButton(context, "Get Catalog", Icons.download, const GetCatalogPage()),
// //                   _dashboardButton(context, "Add to Cart", Icons.add_shopping_cart, const CartPage()),
// //                   _dashboardButton(context, "Apply Promo", Icons.percent, const PromoCodePage()),
// //                   _dashboardButton(context, "Place Order", Icons.check_circle, const PlaceOrderPage()),
// //                   // _dashboardButton(context, "Create Order", Icons.edit, const CreateOrderPage()),
// //                   _dashboardButton(context, "Track Order", Icons.track_changes, const TrackOrderPage()),
// //                   _dashboardButton(context, "Order History", Icons.history, const OrderHistoryPage()),
// //                   _dashboardButton(context, "Order Confirmation", Icons.mark_email_read, const OrderConfirmationPage()),
// //                 ],
// //               ),
// //             ),
// //             const SizedBox(height: 16),
// //             const Text("Stock Management",
// //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// //             const SizedBox(height: 8),
// //             SizedBox(
// //               width: double.infinity,
// //               child: _dashboardButton(context, "Update Stock", Icons.inventory, const StockPage()),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   // Reusable drawer item
// //   Widget _drawerItem(BuildContext context, String title, Widget page) {
// //     return ListTile(
// //       title: Text(title),
// //       onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
// //     );
// //   }

// //   // Reusable dashboard button
// //   Widget _dashboardButton(BuildContext context, String title, IconData icon, Widget page) {
// //     return ElevatedButton(
// //       style: ElevatedButton.styleFrom(
// //         backgroundColor: AppColors.primary,
// //         foregroundColor: Colors.white,
// //         padding: const EdgeInsets.all(12),
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //       ),
// //       onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           Icon(icon, size: 32),
// //           const SizedBox(height: 8),
// //           Text(title, textAlign: TextAlign.center),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import '../../constants/colors.dart';
// import '../widgets/browsecatalogpage.dart';
// import '../widgets/Getcatalogpage.dart';
// import '../widgets/Addtocartpage.dart';
// import '../widgets/Addpromocode.dart';
// import '../widgets/Placeorderpage.dart';
// import '../widgets/Trackorderpage.dart';
// import '../widgets/Orderhistorypage.dart';
// import '../widgets/Orderconfirmationpage.dart';
// import 'ManageStockPage.dart';

// class DistributorHomePage extends StatelessWidget {
//   const DistributorHomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Distributor Dashboard"),
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       drawer: _buildDrawer(context),
//       body: Container(
//         color: AppColors.backgroundColor,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildWelcomeCard(),
//               const SizedBox(height: 24),
//               _buildQuickActions(context),
//               const SizedBox(height: 24),
//               _buildStockSection(context),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Drawer
//   Widget _buildDrawer(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           const DrawerHeader(
//             decoration: BoxDecoration(color: AppColors.primary),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CircleAvatar(
//                   radius: 28,
//                   backgroundColor: Colors.white,
//                   child: Icon(Icons.business, size: 32, color: AppColors.primary),
//                 ),
//                 SizedBox(height: 12),
//                 Text(
//                   'Distributor',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           ListTile(
//             leading: const Icon(Icons.logout),
//             title: const Text("Sign Out"),
//             onTap: () => Navigator.pushReplacementNamed(context, '/login'),
//           ),
//         ],
//       ),
//     );
//   }

//   // Welcome card
//   Widget _buildWelcomeCard() {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       margin: EdgeInsets.zero,
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           gradient: LinearGradient(
//             colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Row(
//           children: [
//             const Icon(Icons.storefront, color: Colors.white, size: 48),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: const [
//                   Text(
//                     'Welcome, Distributor!',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 6),
//                   Text(
//                     'Manage products, orders and stock efficiently',
//                     style: TextStyle(color: Colors.white70, fontSize: 14),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Quick actions (Catalog & Orders)
//   Widget _buildQuickActions(BuildContext context) {
//     return Card(
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: const BorderSide(color: AppColors.primary, width: 1.2),
//       ),
//       margin: EdgeInsets.zero,
//       color: Colors.white,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Catalog & Orders',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.textPrimary,
//               ),
//             ),
//             const SizedBox(height: 24),
//             GridView.count(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               crossAxisCount: 2,
//               crossAxisSpacing: 16,
//               mainAxisSpacing: 16,
//               childAspectRatio: 1.2,
//               children: [
//                 _buildActionButton(context, Icons.list, "Browse Catalog", const CategoryPage()),
//                 _buildActionButton(context, Icons.download, "Get Catalog", const GetCatalogPage()),
//                 _buildActionButton(context, Icons.add_shopping_cart, "Add to Cart", const CartPage()),
//                 _buildActionButton(context, Icons.percent, "Apply Promo", const PromoCodePage()),
//                 _buildActionButton(context, Icons.check_circle, "Place Order", const PlaceOrderPage()),
//                 _buildActionButton(context, Icons.track_changes, "Track Order", const TrackOrderPage()),
//                 _buildActionButton(context, Icons.history, "Order History", const OrderHistoryPage()),
//                 _buildActionButton(context, Icons.mark_email_read, "Order Confirmation", const OrderConfirmationPage()),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Stock section
//   Widget _buildStockSection(BuildContext context) {
//     return Card(
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: const BorderSide(color: AppColors.primary, width: 1.2),
//       ),
//       margin: EdgeInsets.zero,
//       color: Colors.white,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Stock Management',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.textPrimary,
//               ),
//             ),
//             const SizedBox(height: 24),
//             _buildActionButton(context, Icons.inventory, "Update Stock",  StockManagementScreen()),
//           ],
//         ),
//       ),
//     );
//   }

//   // Reusable action button
//   Widget _buildActionButton(BuildContext context, IconData icon, String label, Widget page) {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         elevation: 2,
//         padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
//       ),
//       onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, size: 28, color: Colors.white),
//           const SizedBox(height: 8),
//           Text(
//             label,
//             textAlign: TextAlign.center,
//             style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../widgets/browsecatalogpage.dart';
import '../widgets/Getcatalogpage.dart';
import '../widgets/Addtocartpage.dart';
import '../widgets/Addpromocode.dart';
import '../widgets/Placeorderpage.dart';
import '../widgets/Trackorderpage.dart';
import '../widgets/Orderhistorypage.dart';
import '../widgets/Orderconfirmationpage.dart';
import 'ManageStockPage.dart';

class DistributorHomePage extends StatelessWidget {
  const DistributorHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Distributor Dashboard"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: _buildModernDrawer(context),
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
              const SizedBox(height: 24),
              _buildStockSection(context),
            ],
          ),
        ),
      ),
    );
  }

  // Modern navigation drawer
  Widget _buildModernDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: AppColors.primary),
              child: Row(
                children: const [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.business, size: 36, color: AppColors.primary),
                  ),
                  SizedBox(width: 16),
                  Text(
                    'Distributor',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      "Catalog & Orders",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  _buildDrawerItem(context, Icons.list, "Browse Catalog", const CategoryPage()),
                  _buildDrawerItem(context, Icons.download, "Get Catalog", const GetCatalogPage()),
                  _buildDrawerItem(context, Icons.add_shopping_cart, "Add to Cart", const CartPage()),
                  _buildDrawerItem(context, Icons.percent, "Apply Promo", const PromoCodePage()),
                  _buildDrawerItem(context, Icons.check_circle, "Place Order", const PlaceOrderPage()),
                  _buildDrawerItem(context, Icons.track_changes, "Track Order", const TrackOrderPage()),
                  _buildDrawerItem(context, Icons.history, "Order History", const OrderHistoryPage()),
                  _buildDrawerItem(context, Icons.mark_email_read, "Order Confirmation", const OrderConfirmationPage()),

                  const Divider(),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      "Stock Management",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  _buildDrawerItem(context, Icons.inventory, "Manage Stock", const StockManagementScreen()),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.primary),
              title: const Text("Sign Out"),
              onTap: () => Navigator.pushReplacementNamed(context, '/login'),
            ),
          ],
        ),
      ),
    );
  }

  // Drawer reusable item
  Widget _buildDrawerItem(BuildContext context, IconData icon, String label, Widget page) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(label, style: const TextStyle(color: AppColors.textPrimary)),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
    );
  }

  // Welcome card
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
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.storefront, color: Colors.white, size: 48),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Welcome, Distributor!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Manage products, orders and stock efficiently',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Quick actions card
  Widget _buildQuickActions(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.primary, width: 1.2),
      ),
      margin: EdgeInsets.zero,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Catalog & Orders',
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
              childAspectRatio: 1.2,
              children: [
                _buildActionButton(context, Icons.list, "Browse Catalog", const CategoryPage()),
                _buildActionButton(context, Icons.download, "Get Catalog", const GetCatalogPage()),
                _buildActionButton(context, Icons.add_shopping_cart, "Add to Cart", const CartPage()),
                _buildActionButton(context, Icons.percent, "Apply Promo", const PromoCodePage()),
                _buildActionButton(context, Icons.check_circle, "Place Order", const PlaceOrderPage()),
                _buildActionButton(context, Icons.track_changes, "Track Order", const TrackOrderPage()),
                _buildActionButton(context, Icons.history, "Order History", const OrderHistoryPage()),
                _buildActionButton(context, Icons.mark_email_read, "Order Confirmation", const OrderConfirmationPage()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Stock section card
  Widget _buildStockSection(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.primary, width: 1.2),
      ),
      margin: EdgeInsets.zero,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Stock Management',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            _buildActionButton(context, Icons.inventory, "Update Stock", const StockManagementScreen()),
          ],
        ),
      ),
    );
  }

  // Reusable action button
  Widget _buildActionButton(BuildContext context, IconData icon, String label, Widget page) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
      ),
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28, color: Colors.white),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
