import '../../constants/colors.dart';
import './worker_drawer.dart';
import 'package:flutter/material.dart';
import '../controllers/production.dart';
import '../widgets/production.dart';

class WorkerProductionScreen extends StatefulWidget {
  const WorkerProductionScreen({super.key});

  @override
  State<WorkerProductionScreen> createState() => WorkerProductionScreenState();
}

class WorkerProductionScreenState extends State<WorkerProductionScreen> {
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
        controller.locationController.clear();
        controller.status = 'Available';
      });
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
      drawer: WorkerDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: WorkerProductionForm(
          controller: controller,
          onSubmit: handleSubmit,
          isLoading: isLoading,
        ),
      ),
    );
  }
}
