import 'package:flutter/material.dart';
import '../controllers/manage_stock.dart';
import '../widgets/manage_stock.dart';
import '../../constants/colors.dart';
import './worker_drawer.dart';

class WorkerManageStockScreen extends StatefulWidget {
  const WorkerManageStockScreen({super.key});

  @override
  State<WorkerManageStockScreen> createState() =>
      _WorkerManageStockScreenState();
}

class _WorkerManageStockScreenState extends State<WorkerManageStockScreen> {
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

  Future<void> handleSubmit() async {
    setState(() => isLoading = true);

    await controller.updateStock(context);

    setState(() {
      isLoading = false;
      controller.locationController.clear();
      controller.selectedStatus = "Available"; // reset dropdown
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
      drawer: const WorkerDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: WorkerManageStockForm(
          controller: controller,
          onSubmit: isLoading ? null : handleSubmit,
          isLoading: isLoading,
        ),
      ),
    );
  }
}
