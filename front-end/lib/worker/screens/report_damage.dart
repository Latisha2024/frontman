import '../../constants/colors.dart';
import './worker_drawer.dart';
import 'package:flutter/material.dart';
import '../controllers/report_damage.dart';
import '../widgets/report_damage.dart';

class WorkerReportDamageScreen extends StatefulWidget {
  const WorkerReportDamageScreen({super.key});

  @override
  State<WorkerReportDamageScreen> createState() => WorkerReportDamageScreenState();
}

class WorkerReportDamageScreenState extends State<WorkerReportDamageScreen> {
  late WorkerReportDamageController controller;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    controller = WorkerReportDamageController();
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
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Damage'),
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
        child: WorkerReportDamageForm(
          controller: controller,
          onSubmit: handleSubmit,
          isLoading: isLoading,
        ),
      ),
    );
  }
}