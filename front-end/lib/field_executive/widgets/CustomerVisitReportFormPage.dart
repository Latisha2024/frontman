import 'package:flutter/material.dart';
import '../../constants/colors.dart'; // Ensure AppColors is defined here

class CustomerVisitReportFormPage extends StatefulWidget {
  const CustomerVisitReportFormPage({super.key});

  @override
  State<CustomerVisitReportFormPage> createState() => _CustomerVisitReportFormPageState();
}

class _CustomerVisitReportFormPageState extends State<CustomerVisitReportFormPage> {
  final customerController = TextEditingController(text: "ABC Pvt Ltd");
  final locationController = TextEditingController(text: "Chennai");
  final presentController = TextEditingController(text: "Mr. Kumar, Ms. Priya");
  final productsController = TextEditingController(text: "Product X, Product Y");
  final reasonController = TextEditingController(text: "Regular check-in & product feedback");
  final concernsController = TextEditingController(text: "Packaging issues reported");
  final feedbackController = TextEditingController(text: "Customer appreciated the support.");
  final reportByController = TextEditingController(text: "John Doe");

  String investigation = "Ongoing";
  String rootCause = "Product defect";
  String correctiveAction = "Replace batch";
  String recommendation = "Increase QA checks";
  DateTime? visitDate = DateTime.now();

  Future<void> _selectVisitDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: visitDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => visitDate = picked);
    }
  }

  Widget sectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget buildDropdown(String label, String value, List<String> options, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
          items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _submitReport() {
    String summary = '''
Customer: ${customerController.text}
Date of Visit: ${visitDate != null ? "${visitDate!.day}/${visitDate!.month}/${visitDate!.year}" : 'Not selected'}
Location: ${locationController.text}
Present: ${presentController.text}
Products: ${productsController.text}
Reason: ${reasonController.text}

Concerns: ${concernsController.text}
Investigation: $investigation
Root Cause: $rootCause
Corrective Action: $correctiveAction
Recommendations: $recommendation

General Feedback: ${feedbackController.text}
Report Completed By: ${reportByController.text}
''';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Visit Report Submitted"),
        content: SingleChildScrollView(child: Text(summary)),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text("Customer Visit Report"),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            sectionTitle("INFORMATION"),
            buildField("Customer", customerController),
            Row(
              children: [
                const Text("Date of Visit: ", style: TextStyle(fontWeight: FontWeight.w600)),
                TextButton.icon(
                  onPressed: () => _selectVisitDate(context),
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    visitDate != null
                        ? "${visitDate!.day}/${visitDate!.month}/${visitDate!.year}"
                        : "Select Date",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            buildField("Location", locationController),
            buildField("People Present", presentController),
            buildField("Products Discussed", productsController, maxLines: 2),
            buildField("Reason for Visit", reasonController),

            sectionTitle("QUALITY"),
            buildField("Customer Concerns", concernsController, maxLines: 2),
            buildDropdown("Investigation Status", investigation, ["None", "Ongoing", "Resolved"], (val) {
              if (val != null) setState(() => investigation = val);
            }),
            buildDropdown("Root Cause", rootCause, ["None", "Product defect", "Miscommunication"], (val) {
              if (val != null) setState(() => rootCause = val);
            }),
            buildDropdown("Corrective Action", correctiveAction, ["None", "Replace batch", "Schedule meeting"], (val) {
              if (val != null) setState(() => correctiveAction = val);
            }),
            buildDropdown("Recommendations", recommendation, ["None", "Increase QA checks", "Follow-up visit"], (val) {
              if (val != null) setState(() => recommendation = val);
            }),

            sectionTitle("GENERAL FEEDBACK"),
            buildField("Feedback / Comments", feedbackController, maxLines: 2),
            buildField("Report Completed By", reportByController),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submitReport,
                icon: const Icon(Icons.save_alt),
                label: const Text("Submit Report"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
