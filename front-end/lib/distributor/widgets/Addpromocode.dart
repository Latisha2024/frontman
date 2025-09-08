// // // promo_page.dart
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import '../../authpage/pages/auth_services.dart';

// class PromoPage extends StatefulWidget {
//   const PromoPage({super.key});

//   @override
//   State<PromoPage> createState() => _PromoPageState();
// }

// class _PromoPageState extends State<PromoPage> {
//   final TextEditingController promoCodeController = TextEditingController();
//   final TextEditingController orderAmountController = TextEditingController();
//   final dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:5000"));

//   bool loading = false;
//   String? message;
//   List<dynamic> activePromos = [];

//   Future<String?> _getToken() async {
//     final authService = AuthService();
//     return await authService.getToken();
//   }

//   Future<void> applyPromo() async {
//     setState(() {
//       loading = true;
//       message = null;
//     });
//     try {
//       final token = await _getToken();
//       if (token == null) {
//         setState(() => message = "⚠️ Please login again.");
//         return;
//       }

//       final response = await dio.post(
//         "/distributor/promo/apply",
//         data: {
//           "promoCode": promoCodeController.text,
//           "orderAmount": double.tryParse(orderAmountController.text) ?? 0,
//         },
//         options: Options(headers: {"Authorization": "Bearer $token"}),
//       );

//       final promoData = response.data['promoCode'];
//       setState(() {
//         message =
//             "✅ Applied: ${promoData['code']} | Discount: ${promoData['discountAmount']} | Final: ${promoData['finalAmount']}";
//       });
//     } catch (e) {
//       setState(() => message = "❌ Error: $e");
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   Future<void> validatePromo() async {
//     setState(() {
//       loading = true;
//       message = null;
//     });
//     try {
//       final token = await _getToken();
//       if (token == null) {
//         setState(() => message = "⚠️ Please login again.");
//         return;
//       }

//       final response = await dio.post(
//         "/distributor/promo/validate",
//         data: {
//           "promoCode": promoCodeController.text,
//           "orderAmount": double.tryParse(orderAmountController.text) ?? 0,
//         },
//         options: Options(headers: {"Authorization": "Bearer $token"}),
//       );

//       final promoData = response.data['promoCode'];
//       setState(() {
//         message =
//             "🔍 Valid: ${promoData['code']} | Discount: ${promoData['discountAmount']} | Final: ${promoData['finalAmount']}";
//       });
//     } catch (e) {
//       setState(() => message = "❌ Error: $e");
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   Future<void> getActivePromos() async {
//     setState(() {
//       loading = true;
//       message = null;
//       activePromos.clear();
//     });
//     try {
//       final token = await _getToken();
//       if (token == null) {
//         setState(() => message = "⚠️ Please login again.");
//         return;
//       }

//       final response = await dio.get(
//         "/distributor/promo/active",
//         options: Options(headers: {"Authorization": "Bearer $token"}),
//       );

//       setState(() {
//         activePromos = response.data is List ? response.data : [];
//       });
//     } catch (e) {
//       setState(() => message = "❌ Error: $e");
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   Widget _buildPromoCard(dynamic promo) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
//       child: ListTile(
//         title: Text(
//           promo['code'] ?? "Unknown Code",
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         subtitle: Text(promo['description'] ?? "No description available"),
//         trailing: Text(
//           promo['discountType'] == "percentage"
//               ? "${promo['discountValue']}%"
//               : "\$${promo['discountValue']}",
//           style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Distributor Promo Codes")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: promoCodeController,
//               decoration: const InputDecoration(
//                 labelText: "Enter Promo Code",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: orderAmountController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(
//                 labelText: "Enter Order Amount",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 12),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: loading ? null : applyPromo,
//                   icon: const Icon(Icons.check_circle),
//                   label: const Text("Apply"),
//                 ),
//                 ElevatedButton.icon(
//                   onPressed: loading ? null : validatePromo,
//                   icon: const Icon(Icons.verified),
//                   label: const Text("Validate"),
//                 ),
//                 ElevatedButton.icon(
//                   onPressed: loading ? null : getActivePromos,
//                   icon: const Icon(Icons.local_offer),
//                   label: const Text("Active"),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 20),

//             if (loading) const CircularProgressIndicator(),

//             if (message != null) ...[
//               const SizedBox(height: 12),
//               Text(
//                 message!,
//                 style: TextStyle(
//                   color: message!.startsWith("✅") || message!.startsWith("🔍")
//                       ? Colors.green
//                       : Colors.red,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],

//             if (activePromos.isNotEmpty) ...[
//               const SizedBox(height: 20),
//               const Text(
//                 "Active Promo Codes",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: activePromos.length,
//                 itemBuilder: (context, index) {
//                   return _buildPromoCard(activePromos[index]);
//                 },
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
// promo_code_page.dart
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../authpage/pages/auth_services.dart';

class PromoCodePage extends StatefulWidget {
  const PromoCodePage({super.key});

  @override
  State<PromoCodePage> createState() => _PromoCodePageState();
}

class _PromoCodePageState extends State<PromoCodePage> {
  final TextEditingController promoCodeController = TextEditingController();
  final TextEditingController orderAmountController = TextEditingController();
  final dio = Dio(BaseOptions(baseUrl: "https://frontman-backend-2.onrender.com/"));

  bool loading = false;
  String? message;
  List<dynamic> activePromoCodes = [];

  Future<String?> _getToken() async {
    final authService = AuthService();
    return await authService.getToken();
  }

  Future<void> applyPromoCode() async {
    setState(() {
      loading = true;
      message = null;
    });
    try {
      final token = await _getToken();
      if (token == null) {
        setState(() => message = "⚠️ Please login again.");
        return;
      }

      final response = await dio.post(
        "/distributor/promo/apply",
        data: {
          "promoCode": promoCodeController.text,
          "orderAmount": double.tryParse(orderAmountController.text) ?? 0,
        },
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      setState(() {
        message = "✅ Applied: ${response.data}";
      });
    } catch (e) {
      setState(() => message = "❌ Error: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> validatePromoCode() async {
    setState(() {
      loading = true;
      message = null;
    });
    try {
      final token = await _getToken();
      if (token == null) {
        setState(() => message = "⚠️ Please login again.");
        return;
      }

      final response = await dio.post(
        "/distributor/promo/validate",
        data: {
          "promoCode": promoCodeController.text,
          "orderAmount": double.tryParse(orderAmountController.text) ?? 0,
        },
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      setState(() {
        message = "🔍 Validation: ${response.data}";
      });
    } catch (e) {
      setState(() => message = "❌ Error: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> getActivePromoCodes() async {
    setState(() {
      loading = true;
      message = null;
    });
    try {
      final token = await _getToken();
      if (token == null) {
        setState(() => message = "⚠️ Please login again.");
        return;
      }

      final response = await dio.get(
        "/distributor/promo/active",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      setState(() {
        activePromoCodes = response.data;
        message = "📋 Active Promo Codes fetched!";
      });
    } catch (e) {
      setState(() => message = "❌ Error: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Distributor Promo Codes")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: promoCodeController,
              decoration: const InputDecoration(labelText: "Promo Code"),
            ),
            TextField(
              controller: orderAmountController,
              decoration: const InputDecoration(labelText: "Order Amount"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: loading ? null : applyPromoCode,
              child: const Text("🎟️ Apply Promo Code"),
            ),
            ElevatedButton(
              onPressed: loading ? null : validatePromoCode,
              child: const Text("🔍 Validate Promo Code"),
            ),
            ElevatedButton(
              onPressed: loading ? null : getActivePromoCodes,
              child: const Text("📋 Get Active Promo Codes"),
            ),
            const SizedBox(height: 20),

            if (loading) const CircularProgressIndicator(),
            if (message != null) Text(message!),

            if (activePromoCodes.isNotEmpty) ...[
              const Divider(),
              const Text("Active Promo Codes:", style: TextStyle(fontWeight: FontWeight.bold)),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: activePromoCodes.length,
                itemBuilder: (context, index) {
                  final promo = activePromoCodes[index];
                  return ListTile(
                    title: Text("${promo['code']} (${promo['discountType']} - ${promo['discountValue']})"),
                    subtitle: Text(promo['description'] ?? "No description"),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

