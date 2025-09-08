// catalog_orders_page.dart
import 'package:flutter/material.dart';
import '../widgets/browsecatalogpage.dart';
import '../widgets/Getcatalogpage.dart';
import '../widgets/Addtocartpage.dart';
import '../widgets/Addpromocode.dart';
import '../widgets/Placeorderpage.dart';
//import '../widgets/createorderpage.dart';
import '../widgets/Trackorderpage.dart';
import '../widgets/Orderhistorypage.dart';
import '../widgets/Orderconfirmationpage.dart';

class CatalogOrdersPage extends StatelessWidget {
  const CatalogOrdersPage({super.key});

  Widget buildOptionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 6,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 32, color: const Color(0xFFA5C8D0)),
            const SizedBox(width: 16),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Catalog & Orders"),
        backgroundColor: const Color(0xFFA5C8D0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            buildOptionCard(
              icon: Icons.view_list,
              title: "Browse Product Catalog",
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryPage())),
            ),
            buildOptionCard(
              icon: Icons.list_alt,
              title: "Get Product Catalog",
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GetCatalogPage())),
            ),
            buildOptionCard(
              icon: Icons.add_shopping_cart,
              title: "Add Products to Cart",
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage())),
            ),
            buildOptionCard(
              icon: Icons.discount,
              title: "Apply Promo Code",
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PromoCodePage())),
            ),
            buildOptionCard(
              icon: Icons.shopping_cart_checkout,
              title: "Place Order",
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PlaceOrderPage())),
            ),
            // buildOptionCard(
            //   icon: Icons.playlist_add,
            //   title: "Create Order",
            //   onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateOrderPage())),
            // ),
            buildOptionCard(
              icon: Icons.track_changes,
              title: "Track Order Status",
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TrackOrderPage())),
            ),
            buildOptionCard(
              icon: Icons.history,
              title: "View Order History",
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderHistoryPage())),
            ),
            buildOptionCard(
              icon: Icons.verified,
              title: "Receive Order Confirmation",
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderConfirmationPage())),
            ),
          ],
        ),
      ),
    );
  }
}
