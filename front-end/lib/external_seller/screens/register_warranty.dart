import './seller_drawer.dart';
import 'package:flutter/material.dart';
import '../controllers/register_warranty.dart';
import '../widgets/register_warranty.dart';
import '../../../constants/colors.dart';

class ExternalSellerRegisterWarrantyScreen extends StatefulWidget {
  const ExternalSellerRegisterWarrantyScreen({super.key});

  @override
  State<ExternalSellerRegisterWarrantyScreen> createState() =>
      _ExternalSellerRegisterWarrantyScreenState();
}

class _ExternalSellerRegisterWarrantyScreenState
    extends State<ExternalSellerRegisterWarrantyScreen> {
  final controller = ExternalSellerRegisterWarrantyController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      controller.sellerIdController.text = arguments['sellerId'] ?? '';
      controller.productIdController.text = arguments['productId'] ?? '';
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void handleSubmit() {
    controller.submitWarranty();
    Future.delayed(const Duration(milliseconds: 600), () {
      if (controller.success == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Log has been made to the admin!')),
        );
        clearForm();
      } else if (controller.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(controller.error!)),
        );
      }
    });
  }

  void clearForm() {
    controller.productIdController.clear();
    controller.serialNumberController.clear();
    controller.purchaseDateController.clear();
    controller.warrantyMonthsController.clear();
    controller.sellerIdController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Warranty'),
        backgroundColor: AppColors.primaryBlue,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: const SellerDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RegisterWarrantyForm(
                    controller: controller,
                    onSubmit: handleSubmit,
                    isLoading: controller.isLoading,
                  ),
                  if (controller.qrCodeData != null) ...[
                    const SizedBox(height: 24),
                    QRCodeDisplay(qrCodeData: controller.qrCodeData!),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
