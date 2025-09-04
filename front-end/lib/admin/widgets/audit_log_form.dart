import 'package:flutter/material.dart';
import '../controllers/audit_logs.dart';

class AuditLogForm extends StatefulWidget {
  final AdminAuditLogsController controller;

  const AuditLogForm({super.key, required this.controller});

  @override
  State<AuditLogForm> createState() => _AuditLogFormState();
}

class _AuditLogFormState extends State<AuditLogForm> {
  final _formKey = GlobalKey<FormState>();
  final _actionController = TextEditingController();
  final _resourceController = TextEditingController();
  final _detailsController = TextEditingController();

  @override
  void dispose() {
    _actionController.dispose();
    _resourceController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.controller.createAuditLog(
        action: _actionController.text,
        resource: _resourceController.text,
        details: _detailsController.text.isNotEmpty ? _detailsController.text : null,
      );
      Navigator.of(context).pop(); // Close the dialog on submit
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Audit Log'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _actionController,
                decoration: const InputDecoration(labelText: 'Action'),
                validator: (value) => value!.isEmpty ? 'Action is required' : null,
              ),
              TextFormField(
                controller: _resourceController,
                decoration: const InputDecoration(labelText: 'Resource'),
                validator: (value) => value!.isEmpty ? 'Resource is required' : null,
              ),
              TextFormField(
                controller: _detailsController,
                decoration: const InputDecoration(labelText: 'Details (Optional)'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Create'),
        ),
      ],
    );
  }
}
