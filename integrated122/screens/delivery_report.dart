import 'package:app/modules/external_seller/screens/seller_drawer.dart';
import 'package:flutter/material.dart';
import '../controllers/delivery_report.dart';
import '../widgets/delivery_report.dart';
import '../../../constants/colors.dart';

class ExternalSellerDeliveryReportScreen extends StatefulWidget {
  const ExternalSellerDeliveryReportScreen({super.key});

  @override
  State<ExternalSellerDeliveryReportScreen> createState() => ExternalSellerDeliveryReportScreenState();
}

class ExternalSellerDeliveryReportScreenState extends State<ExternalSellerDeliveryReportScreen> {
  final controller = ExternalSellerDeliveryReportController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void handleQrRequestedChanged(bool value) {
    setState(() {
      controller.qrRequested = value;
    });
  }

  void handleSubmit() {
    setState(() {
      controller.submitReport();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (controller.success == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Delivery report submitted successfully!')),
        );
        controller.sellerIdController.clear();
        controller.productController.clear();
        controller.quantityController.clear();
        controller.qrRequested = false;
        setState(() {});
      } else if (controller.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(controller.error!)),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Delivery Report'),
        backgroundColor: AppColors.flowerBlue,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: SellerDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            return DeliveryReportForm(
              controller: controller,
              onSubmit: handleSubmit,
              isLoading: controller.isLoading,
              onQrRequestedChanged: handleQrRequestedChanged,
            );
          },
        ),
      ),
    );
  }
}
