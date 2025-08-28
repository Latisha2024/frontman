import 'package:flutter/material.dart';
import '../controllers/shift_alerts.dart';
import '../screens/admin_drawer.dart';
import '../../constants/colors.dart';
import '../../sales_manager/screens/sales_manager_drawer.dart';
import 'company_selection.dart';

class ShiftAlertsScreen extends StatefulWidget {
  final Company? company;
  final String role;
  const ShiftAlertsScreen({super.key, this.company, required this.role});

  @override
  State<ShiftAlertsScreen> createState() => _ShiftAlertsScreenState();
}

class _ShiftAlertsScreenState extends State<ShiftAlertsScreen> {
  late AdminShiftAlertsController controller;

  @override
  void initState() {
    super.initState();
    controller = AdminShiftAlertsController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      controller.shiftDateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      controller.shiftTimeController.text = "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Shift Alerts',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (widget.company != null)
                  Text(
                    widget.company!.name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.white70,
                    ),
                  ),
              ],
            ),
            backgroundColor: AppColors.primaryBlue,
            elevation: 0,
          ),
          drawer: widget.role == "admin" 
              ? AdminDrawer(company: widget.company) 
              : SalesManagerDrawer(company: widget.company),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Show error or success messages
                if (controller.error != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error, color: Colors.red.shade700),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            controller.error!,
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                        IconButton(
                          onPressed: controller.clearMessages,
                          icon: Icon(Icons.close, color: Colors.red.shade700),
                        ),
                      ],
                    ),
                  ),
                if (controller.successMessage != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green.shade700),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            controller.successMessage!,
                            style: TextStyle(color: Colors.green.shade700),
                          ),
                        ),
                        IconButton(
                          onPressed: controller.clearMessages,
                          icon: Icon(Icons.close, color: Colors.green.shade700),
                        ),
                      ],
                    ),
                  ),
                // Main form
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Create Shift Alert',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Worker ID field
                        TextFormField(
                          controller: controller.workerIdController,
                          decoration: InputDecoration(
                            labelText: 'Worker ID *',
                            hintText: 'Enter worker ID',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.person),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Title field
                        TextFormField(
                          controller: controller.titleController,
                          decoration: const InputDecoration(
                            labelText: 'Alert Title *',
                            hintText: 'Enter alert title',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.title),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Message field
                        TextFormField(
                          controller: controller.messageController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Alert Message *',
                            hintText: 'Enter detailed alert message',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.message),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Date field
                        TextFormField(
                          controller: controller.shiftDateController,
                          readOnly: true,
                          onTap: _selectDate,
                          decoration: const InputDecoration(
                            labelText: 'Shift Date *',
                            hintText: 'Select shift date',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.calendar_today),
                            suffixIcon: Icon(Icons.arrow_drop_down),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Time field
                        TextFormField(
                          controller: controller.shiftTimeController,
                          readOnly: true,
                          onTap: _selectTime,
                          decoration: const InputDecoration(
                            labelText: 'Shift Time *',
                            hintText: 'Select shift time',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.access_time),
                            suffixIcon: Icon(Icons.arrow_drop_down),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Action buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: controller.isLoading
                                    ? null
                                    : controller.createShiftAlert,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryBlue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: controller.isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : const Text('Create Alert'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: controller.clearForm,
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: const Text('Clear Form'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
