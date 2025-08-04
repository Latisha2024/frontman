import 'package:flutter/material.dart';
import '../controllers/validate_warranty.dart';
import '../widgets/validate_warranty.dart';
import '../../../constants/colors.dart';
import './seller_drawer.dart';

class ExternalSellerValidateRegistrationScreen extends StatefulWidget {
  const ExternalSellerValidateRegistrationScreen({super.key});

  @override
  State<ExternalSellerValidateRegistrationScreen> createState() =>
      _ExternalSellerValidateRegistrationScreenState();
}

class _ExternalSellerValidateRegistrationScreenState
    extends State<ExternalSellerValidateRegistrationScreen> {
  final controller = ValidateWarrantyController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Validate Registration'),
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
            return ValidateRegistrationWidget(controller: controller);
          },
        ),
      ),
    );
  }
}
