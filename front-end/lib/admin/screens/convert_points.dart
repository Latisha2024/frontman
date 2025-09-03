import '../../constants/colors.dart';
import 'package:flutter/material.dart';
import '../../sales_manager/screens/sales_manager_drawer.dart';
import '../controllers/convert_points.dart';
import '../widgets/convert_points.dart';
import 'admin_drawer.dart';

class ConvertPointsToCashScreen extends StatefulWidget {
  final String role;
  const ConvertPointsToCashScreen({super.key, required this.role});

  @override
  State<ConvertPointsToCashScreen> createState() => ConvertPointsToCashScreenState();
}

class ConvertPointsToCashScreenState extends State<ConvertPointsToCashScreen> {
  final controller = AdminConvertPointsController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Points',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: AppColors.primaryBlue,
            elevation: 0,
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  controller.fetchAllTransactions();
                },
                icon: const Icon(Icons.refresh, color: Colors.white),
                tooltip: 'Refresh Transactions',
              ),
            ],
          ),
          drawer: widget.role == "admin" ? AdminDrawer() : SalesManagerDrawer(),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Main content
                Expanded(
                  child: ConvertPointsToCashForm(controller: controller),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
