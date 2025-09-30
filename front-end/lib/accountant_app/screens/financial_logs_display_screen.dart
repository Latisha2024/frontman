import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/accountant_provider.dart';
import '../theme/app_theme.dart';


class FinancialLogsDisplayScreen extends StatefulWidget {
  const FinancialLogsDisplayScreen({Key? key}) : super(key: key);

  @override
  State<FinancialLogsDisplayScreen> createState() => _FinancialLogsDisplayScreenState();
}

class _FinancialLogsDisplayScreenState extends State<FinancialLogsDisplayScreen> {
  String _selectedFilter = 'all';
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountantProvider>().loadFinancialLogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.themeData,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Financial Logs'),
          backgroundColor: AppTheme.primaryColor,
        ),
        // drawer: _buildNavigationDrawer(context), // Assuming you have a drawer
        body: Container(
          color: AppTheme.backgroundColor,
          child: Column(
            children: [
              _buildFilters(),
              Expanded(
                child: _buildLogsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Consumer<AccountantProvider>(
      builder: (context, provider, child) {
        final categories = provider.financialLogs
            .map((log) => log.category)
            .where((c) => c != null)
            .toSet()
            .toList();

        return Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedFilter,
                    decoration: const InputDecoration(labelText: 'Type'),
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('All')),
                      DropdownMenuItem(value: 'income', child: Text('Income')),
                      DropdownMenuItem(value: 'expense', child: Text('Expense')),
                    ],
                    onChanged: (value) {
                      setState(() { _selectedFilter = value!; });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String?>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All Categories')),
                      ...categories.map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category!),
                      )),
                    ],
                    onChanged: (value) {
                      setState(() { _selectedCategory = value; });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogsList() {
    return Consumer<AccountantProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.error != null) {
          return Center(child: Text('Error: ${provider.error}'));
        }

        final filteredLogs = provider.financialLogs.where((log) {
          // FIX: Use case-insensitive comparison for type filter
          final typeMatch = _selectedFilter == 'all' || log.type.toLowerCase() == _selectedFilter;
          final categoryMatch = _selectedCategory == null || log.category == _selectedCategory;
          return typeMatch && categoryMatch;
        }).toList();

        if (filteredLogs.isEmpty) {
          return const Center(child: Text('No logs match your filters.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: filteredLogs.length,
          itemBuilder: (context, index) {
            final log = filteredLogs[index];
            final bool isIncome = log.type.toLowerCase() == 'income';
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isIncome ? AppTheme.primaryLight : AppTheme.accentLight,
                  child: Icon(
                    isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                    color: isIncome ? AppTheme.primaryColor : AppTheme.accentColor,
                  ),
                ),
                title: Text(log.description, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // FIX: Use `createdAt` instead of `date`
                      '${log.category ?? "N/A"} • ${log.createdAt.day}/${log.createdAt.month}/${log.createdAt.year}',
                    ),
                    // FIX: Use `reference` instead of `notes`
                    if (log.reference != null && log.reference!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        log.reference!,
                        style: TextStyle(color: AppTheme.textColor.withOpacity(0.7), fontSize: 12),
                      ),
                    ],
                  ],
                ),
                trailing: Text(
                  '${isIncome ? '+' : '-'}\₹${log.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isIncome ? AppTheme.primaryColor : AppTheme.accentColor,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}