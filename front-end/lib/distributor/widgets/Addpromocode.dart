import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:role_based_app/distributor/screens/distributorsUI.dart';
import '../../authpage/pages/auth_services.dart';

class PromoCodePage extends StatefulWidget {
  const PromoCodePage({super.key});

  @override
  State<PromoCodePage> createState() => _PromoCodePageState();
}

class _PromoCodePageState extends State<PromoCodePage> {
  final TextEditingController promoCodeController = TextEditingController();
  final TextEditingController orderAmountController = TextEditingController();
  final dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:5001"));

  bool loading = false;
  String? message;
  List<dynamic> activePromoCodes = [];

  Future<String?> _getToken() async {
    final authService = AuthService();
    return await authService.getToken();
  }

  /// 🔹 Format backend response into customer-friendly text
  String _formatResponse(dynamic data, {bool applied = false, bool validated = false}) {
    if (data is Map<String, dynamic>) {
      // ✅ match backend key
      final promo = data["promoCode"] ?? {};
      final code = promo["code"] ?? "N/A";
      final desc = promo["description"] ?? "No description available";
      final type = promo["discountType"] ?? "";
      final value = promo["discountValue"]?.toString() ?? "0";
      final discount = promo["discountAmount"]?.toString() ?? "0";
      final finalAmount = promo["finalAmount"]?.toString() ?? "0";

      if (applied) {
        return "🎉 Promo code $code applied successfully!\n"
            "$desc\n\n"
            "🏷️ Discount: $value ($type)\n"
            "💸 You saved ₹$discount\n"
            "💰 Final amount to pay: ₹$finalAmount";
      }

      if (validated) {
        return "🔍 Promo code $code is valid!\n"
            "$desc\n\n"
            "🏷️ Discount: $value ($type)\n"
            "💸 Potential saving: ₹$discount\n"
            "💰 Payable after discount: ₹$finalAmount";
      }
    }
    return data.toString();
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
        message = _formatResponse(response.data, applied: true);
      });
    } catch (e) {
      setState(() => message = "❌ Could not apply promo code.");
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
        message = _formatResponse(response.data, validated: true);
      });
    } catch (e) {
      setState(() => message = "❌ Could not validate promo code.");
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
        message = "📋 Active promo codes fetched successfully!";
      });
    } catch (e) {
      setState(() => message = "❌ Could not fetch active promo codes.");
    } finally {
      setState(() => loading = false);
    }
  }

  Widget _buildActivePromoCard(dynamic promo) {
    final code = promo['code'] ?? "Unknown";
    final desc = promo['description'] ?? "No description";
    final type = promo['discountType'] ?? "";
    final value = promo['discountValue'] ?? 0;

    final offerText = type == "percentage"
        ? "Get $value% off your order"
        : "Save ₹$value on your order";

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text("Promo Code: $code",
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("$desc\n$offerText"),
        trailing: const Icon(Icons.local_offer, color: Colors.green),
      ),
    );
  }

  Widget _buildActionCard({required String title, required List<Widget> children}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Distributor Promo Codes",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: const Icon(Icons.local_offer, size: 26),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, size: 26),
            tooltip: "Back to Dashboard",
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const DistributorHomePage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildActionCard(
              title: "Apply or Validate Promo Code",
              children: [
                TextField(
                  controller: promoCodeController,
                  decoration: const InputDecoration(
                    labelText: "Enter Promo Code",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: orderAmountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Enter Order Amount",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: loading ? null : applyPromoCode,
                      icon: const Icon(Icons.check_circle),
                      label: const Text("Apply"),
                    ),
                    ElevatedButton.icon(
                      onPressed: loading ? null : validatePromoCode,
                      icon: const Icon(Icons.verified),
                      label: const Text("Validate"),
                    ),
                  ],
                ),
              ],
            ),

            if (loading) const SizedBox(height: 16),
            if (loading) const CircularProgressIndicator(),

            if (message != null) ...[
              const SizedBox(height: 16),
              Card(
                color: message!.startsWith("🎉") ||
                        message!.startsWith("🔍") ||
                        message!.startsWith("📋")
                    ? Colors.green[50]
                    : Colors.red[50],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    message!,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: message!.startsWith("🎉") ||
                              message!.startsWith("🔍") ||
                              message!.startsWith("📋")
                          ? Colors.green[900]
                          : Colors.red[900],
                    ),
                  ),
                ),
              ),
            ],

            if (activePromoCodes.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Text(
                "Active Promo Codes",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: activePromoCodes.length,
                itemBuilder: (context, index) {
                  return _buildActivePromoCard(activePromoCodes[index]);
                },
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: getActivePromoCodes,
        icon: const Icon(Icons.local_offer),
        label: const Text("Active Promos"),
      ),
    );
  }
}



