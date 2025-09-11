import './plumber_drawer.dart';
import 'package:flutter/material.dart';
import '../controllers/delivery_report.dart';
import '../widgets/delivery_report.dart';
import '../../constants/colors.dart';

class PlumberDeliveryReportScreen extends StatefulWidget {
  const PlumberDeliveryReportScreen({super.key});

  @override
  State<PlumberDeliveryReportScreen> createState() =>
      PlumberDeliveryReportScreenState();
}

class PlumberDeliveryReportScreenState
    extends State<PlumberDeliveryReportScreen> {
  final controller = PlumberDeliveryReportController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> handleSubmit() async {
    await controller.submitReport();

    if (controller.success == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Delivery report submitted successfully!'),
        ),
      );
      controller.productController.clear();
      controller.quantityController.clear();
      setState(() {});
    } else if (controller.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(controller.error!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Delivery Report'),
        backgroundColor: AppColors.primaryBlue,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: const PlumberDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            return DeliveryReportForm(
              controller: controller,
              onSubmit: handleSubmit,
              isLoading: controller.isLoading,
            );
          },
        ),
      ),
    );
  }
}
