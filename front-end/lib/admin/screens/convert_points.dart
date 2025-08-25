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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Convert Points To Cash'),
        backgroundColor: AppColors.primaryBlue,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: widget.role == "admin" ? AdminDrawer() : SalesManagerDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ConvertPointsToCashForm(controller: controller),
      ),
    );
  }
}
