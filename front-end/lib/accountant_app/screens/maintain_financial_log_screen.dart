import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/financial_log.dart';
import '../providers/accountant_provider.dart';
import '../theme/app_theme.dart';

class MaintainFinancialLogScreen extends StatefulWidget {
  const MaintainFinancialLogScreen({Key? key}) : super(key: key);

  @override
  _MaintainFinancialLogScreenState createState() => _MaintainFinancialLogScreenState();
}

class _MaintainFinancialLogScreenState extends State<MaintainFinancialLogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();
  String? _selectedType;
  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  final List<String> _types = ['Income', 'Expense'];
  final List<String> _categories = ['Salary', 'Rent', 'Utilities', 'Client Payment', 'Other'];

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _isLoading = true);

    try {
      final log = FinancialLog(
        description: _descriptionController.text,
        amount: double.parse(_amountController.text),
        type: _selectedType!,
        category: _selectedCategory,
        createdAt: _selectedDate,
        reference: _referenceController.text.isNotEmpty ? _referenceController.text : null,
      );

      await Provider.of<AccountantProvider>(context, listen: false).addFinancialLog(log);

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Financial log added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding log: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.themeData,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Maintain Financial Log'),
          backgroundColor: AppTheme.primaryColor,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.monetization_on),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.swap_vert),
                  ),
                  items: _types.map((type) {
                    return DropdownMenuItem(value: type, child: Text(type));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                  validator: (value) => value == null ? 'Please select a type' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem(value: category, child: Text(category));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  validator: (value) => value == null ? 'Please select a category' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Date',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.calendar_today),
                    hintText: "${_selectedDate.toLocal()}".split(' ')[0],
                  ),
                  onTap: () => _selectDate(context),
                  controller: TextEditingController(text: "${_selectedDate.toLocal()}".split(' ')[0]),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _referenceController,
                  decoration: const InputDecoration(
                    labelText: 'Reference/Notes (Optional)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.note),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: _submitForm,
                        child: const Text('Save Log'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}