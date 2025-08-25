import 'package:flutter/material.dart';
import '../../constants/colors.dart'; // Uses your AppColors

class PlaceOrderPage extends StatefulWidget {
  const PlaceOrderPage({super.key});

  @override
  State<PlaceOrderPage> createState() => _PlaceOrderPageState();
}

class _PlaceOrderPageState extends State<PlaceOrderPage> {
  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final townController = TextEditingController();
  final postcodeController = TextEditingController();

  String selectedCountry = 'Canada';
  String selectedState = 'Ontario';
  String selectedPayment = 'Card';
  bool subscribe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Place Order"),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          color: AppColors.surface,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("DELIVERY ADDRESS"),
                _buildTextField("Email Address", emailController, "example@mail.com"),
                Row(
                  children: [
                    Expanded(child: _buildTextField("First Name", firstNameController, "John")),
                    const SizedBox(width: 10),
                    Expanded(child: _buildTextField("Last Name", lastNameController, "Doe")),
                  ],
                ),
                _buildTextField("Telephone", phoneController, "+1 234 567 890"),
                _buildTextField("Delivery Address", addressController, "123 Main St, Apt 4B"),
                _buildTextField("Suburb / Town", townController, "Toronto"),
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown("State / Territory", selectedState, ['Ontario', 'Alberta', 'Quebec'], (val) {
                        setState(() => selectedState = val ?? '');
                      }),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: _buildTextField("Postcode", postcodeController, "M5H 2N2")),
                  ],
                ),
                _buildDropdown("Country", selectedCountry, ['Canada', 'USA', 'India'], (val) {
                  setState(() => selectedCountry = val ?? '');
                }),
                Row(
                  children: [
                    Checkbox(value: true, onChanged: (_) {}),
                    const Text("Same billing address"),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSectionTitle("SELECT PAYMENT METHOD"),
                _buildPaymentOption(),
                const SizedBox(height: 24),
                _buildSectionTitle("ORDER SUMMARY"),
                _buildOrderSummary(),
                Row(
                  children: [
                    Checkbox(
                      value: subscribe,
                      onChanged: (val) => setState(() => subscribe = val ?? false),
                    ),
                    const Expanded(
                      child: Text("I'm keen for new releases and subscriber exclusives. Sign me up!"),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Process order
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("PAY NOW", style: TextStyle(fontSize: 16, color: AppColors.buttonText)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          labelStyle: const TextStyle(color: AppColors.textSecondary),
          border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.border)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.inputFocus)),
          filled: true,
          fillColor: AppColors.inputFill,
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.textSecondary),
          border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.border)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.inputFocus)),
          filled: true,
          fillColor: AppColors.inputFill,
        ),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildPaymentOption() {
    return Column(
      children: [
        RadioListTile<String>(
          value: 'Card',
          groupValue: selectedPayment,
          onChanged: (val) => setState(() => selectedPayment = val!),
          title: const Text("Card"),
          activeColor: AppColors.primary,
        ),
        RadioListTile<String>(
          value: 'PayPal',
          groupValue: selectedPayment,
          onChanged: (val) => setState(() => selectedPayment = val!),
          title: const Text("PayPal"),
          activeColor: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildOrderSummary() {
    const subtotal = 109.00;
    const tax = 14.17;
    const total = 123.17;

    return Card(
      color: AppColors.surfaceVariant,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _summaryRow("1 x Note Sleeve, Tan", "\$109"),
            _summaryRow("Shipping to Canada", "FREE", subtitle: "Regular (5–10 business days, tracking)"),
            _summaryRow("Sales Tax", "\$14.17"),
            const Divider(),
            _summaryRow("ORDER TOTAL", "\$123.17 CAD", bold: true),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {String? subtitle, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
              Text(value, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
            ],
          ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }
}
