import '../../constants/colors.dart';
import './worker_drawer.dart';
import 'package:flutter/material.dart';
import '../controllers/manage_stock.dart';
import '../widgets/manage_stock.dart';

class WorkerManageStockScreen extends StatefulWidget {
  const WorkerManageStockScreen({super.key});

  @override
  State<WorkerManageStockScreen> createState() => WorkerManageStockScreenState();
}

class WorkerManageStockScreenState extends State<WorkerManageStockScreen> {
  late WorkerManageStockController controller;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    controller = WorkerManageStockController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void handleSubmit() {
    setState(() {
      isLoading = true;
    });
    // Simulate local update
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isLoading = false;
        controller.productIdController.clear();
        controller.quantityController.clear();
        controller.fromLocationController.clear();
        controller.toLocationController.clear();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Stock'),
        backgroundColor: AppColors.primaryBlue,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: WorkerDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: WorkerManageStockForm(
          controller: controller,
          onSubmit: handleSubmit,
          isLoading: isLoading,
        ),
      ),
    );
  }
} 