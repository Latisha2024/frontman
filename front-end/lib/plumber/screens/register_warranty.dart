// // lib/plumber/screens/register_warranty_screen.dart
// import './plumber_drawer.dart';
// import 'package:flutter/material.dart';
// import '../controllers/register_warranty.dart';
// import '../widgets/register_warranty.dart';
// import '../../constants/colors.dart';

// class PlumberRegisterWarrantyScreen extends StatefulWidget {
//   const PlumberRegisterWarrantyScreen({super.key});

//   @override
//   State<PlumberRegisterWarrantyScreen> createState() =>
//       _PlumberRegisterWarrantyScreenState();
// }

// class _PlumberRegisterWarrantyScreenState
//     extends State<PlumberRegisterWarrantyScreen> {
//   final controller = PlumberRegisterWarrantyController();

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final arguments =
//         ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
//     if (arguments != null) {
//       controller.sellerIdController.text = arguments['sellerId'] ?? '';
//       controller.productIdController.text = arguments['productId'] ?? '';
//     }
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   Future<void> handleSubmit() async {
//     await controller.submitWarranty(); // await instead of delay

//     if (!mounted) return;

//     if (controller.success == true) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Warranty registered successfully!')),
//       );
//       clearForm();
//     } else if (controller.error != null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(controller.error!)),
//       );
//     }
//   }

//   void clearForm() {
//     controller.productIdController.clear();
//     controller.serialNumberController.clear();
//     controller.purchaseDateController.clear();
//     controller.warrantyMonthsController.clear();
//     // sellerId is from JWT on backend; no need to clear unless you want to
//     // controller.sellerIdController.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Register Warranty'),
//         backgroundColor: AppColors.primaryBlue,
//         leading: Builder(
//           builder: (context) => IconButton(
//             icon: const Icon(Icons.menu),
//             onPressed: () => Scaffold.of(context).openDrawer(),
//           ),
//         ),
//       ),
//       drawer: const PlumberDrawer(),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: AnimatedBuilder(
//           animation: controller,
//           builder: (context, _) {
//             return SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   RegisterWarrantyForm(
//                     controller: controller,
//                     onSubmit: handleSubmit,
//                     isLoading: controller.isLoading,
//                   ),
//                   if (controller.qrCodeData != null) ...[
//                     const SizedBox(height: 24),
//                     QRCodeDisplay(qrCodeData: controller.qrCodeData!),
//                   ],
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../controllers/register_warranty.dart';
import '../widgets/register_warranty.dart';
import './plumber_drawer.dart';
import '../../constants/colors.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PlumberRegisterWarrantyScreen extends StatefulWidget {
  const PlumberRegisterWarrantyScreen({super.key});

  @override
  State<PlumberRegisterWarrantyScreen> createState() =>
      _PlumberRegisterWarrantyScreenState();
}

class _PlumberRegisterWarrantyScreenState
    extends State<PlumberRegisterWarrantyScreen> {
  final controller = PlumberRegisterWarrantyController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> handleSubmit() async {
    await controller.submitWarranty();
    if (!mounted) return;

    if (controller.success == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Warranty registered successfully!')),
      );
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
        title: const Text('Register Warranty'),
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
                    Text('Generated QR (for scanning):',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    QrImageView(
                      data: controller.qrCodeData!,
                      version: QrVersions.auto,
                      size: 200,
                    ),
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
