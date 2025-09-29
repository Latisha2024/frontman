import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import './worker_drawer.dart';
import '../controllers/production.dart';
import '../widgets/production.dart';

class WorkerProductionScreen extends StatefulWidget {
  const WorkerProductionScreen({super.key});

  @override
  State<WorkerProductionScreen> createState() => _WorkerProductionScreenState();
}

class _WorkerProductionScreenState extends State<WorkerProductionScreen> {
  late WorkerProductionController controller;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    controller = WorkerProductionController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> handleSubmit() async {
    setState(() => isLoading = true);

    await controller.logProduction(context);

    setState(() {
      isLoading = false;
      controller.productIdController.clear();
      controller.quantityController.clear();
      controller.locationController.clear();
      controller.status = 'Available';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Production'),
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
        child: WorkerProductionForm(
          controller: controller,
          onSubmit: isLoading ? null : handleSubmit,
          isLoading: isLoading,
        ),
      ),
    );
  }
}
