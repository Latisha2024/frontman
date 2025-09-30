import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import './worker_drawer.dart';
import '../controllers/report_damage.dart';
import '../widgets/report_damage.dart';

class WorkerReportDamageScreen extends StatefulWidget {
  const WorkerReportDamageScreen({super.key});

  @override
  State<WorkerReportDamageScreen> createState() =>
      WorkerReportDamageScreenState();
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

  Future<void> handleSubmit() async {
    setState(() {
      isLoading = true;
    });

    final result = await controller.submitDamageReport();

    setState(() {
      isLoading = false;
    });

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Damage report submitted successfully')),
      );

      controller.stockIdController.clear();
      controller.quantityController.clear();
      controller.locationController.clear();
      controller.reasonController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error: ${result['message']}')),
      );
    }
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
