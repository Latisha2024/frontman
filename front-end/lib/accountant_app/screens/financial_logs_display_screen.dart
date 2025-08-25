import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:role_based_app/constants/colors.dart';
import '../providers/accountant_provider.dart';
import '../theme/app_theme.dart';
import 'acc_home_screen.dart';
import 'maintain_financial_log_screen.dart';
import 'track_financial_logs_screen.dart';
import 'generate_invoice_screen.dart';
import 'send_invoice_screen.dart';
import 'verify_payment_screen.dart';
import 'preview_pdf_screen.dart';

class FinancialLogsDisplayScreen extends StatefulWidget {
  const FinancialLogsDisplayScreen({Key? key}) : super(key: key);

  @override
  State<FinancialLogsDisplayScreen> createState() => _FinancialLogsDisplayScreenState();
}

class _FinancialLogsDisplayScreenState extends State<FinancialLogsDisplayScreen> {
  String _selectedFilter = 'all';
  String _selectedCategory = 'all';

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
        drawer: _buildNavigationDrawer(context),
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

  Widget _buildNavigationDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppTheme.primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: AppTheme.primaryColor,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Accountant App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard, color: AppTheme.accentColor),
            title: const Text('Dashboard', style: TextStyle(color: AppTheme.textColor)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountantHomeScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet, color: AppTheme.accentColor),
            title: const Text('Maintain Financial Logs', style: TextStyle(color: AppTheme.textColor)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MaintainFinancialLogScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.analytics, color: AppTheme.accentColor),
            title: const Text('Track Financial Logs', style: TextStyle(color: AppTheme.textColor)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TrackFinancialLogsScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long, color: AppTheme.accentColor),
            title: const Text('Generate Invoice', style: TextStyle(color: AppTheme.textColor)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GenerateInvoiceScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.preview, color: AppTheme.accentColor),
            title: const Text('Preview PDF', style: TextStyle(color: AppTheme.textColor)),
            onTap: () {
              Navigator.pop(context);
              _showPreviewPdfDialog(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.send, color: AppTheme.accentColor),
            title: const Text('Send Invoice', style: TextStyle(color: AppTheme.textColor)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SendInvoiceScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.verified, color: AppTheme.accentColor),
            title: const Text('Verify Payment', style: TextStyle(color: AppTheme.textColor)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VerifyPaymentScreen(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: AppTheme.accentColor),
            title: const Text('Sign Out', style: TextStyle(color: AppTheme.accentColor)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }

  void _showPreviewPdfDialog(BuildContext context) {
    final provider = context.read<AccountantProvider>();
    final availableInvoices = provider.invoices;

    if (availableInvoices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No invoices available to preview'),
          backgroundColor: AppTheme.accentColor,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Invoice to Preview'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: availableInvoices.length,
            itemBuilder: (context, index) {
              final invoice = availableInvoices[index];
              return ListTile(
                title: Text(invoice.clientName),
                subtitle: Text('\$${invoice.amount.toStringAsFixed(2)}'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PreviewPdfScreen(invoice: invoice),
                    ),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Consumer<AccountantProvider>(
      builder: (context, provider, child) {
        final categories = provider.financialLogs
            .map((log) => log.category)
            .toSet()
            .toList();

        return Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedFilter,
                        decoration: const InputDecoration(
                          labelText: 'Type',
                          prefixIcon: Icon(Icons.filter_list, color: AppTheme.accentColor),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'all', child: Text('All', style: TextStyle(color: AppTheme.textColor))),
                          DropdownMenuItem(value: 'income', child: Text('Income', style: TextStyle(color: AppTheme.textColor))),
                          DropdownMenuItem(value: 'expense', child: Text('Expense', style: TextStyle(color: AppTheme.textColor))),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedFilter = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          prefixIcon: Icon(Icons.category, color: AppTheme.accentColor),
                        ),
                        items: [
                          const DropdownMenuItem(value: 'all', child: Text('All Categories', style: TextStyle(color: AppTheme.textColor))),
                          ...categories.map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category, style: const TextStyle(color: AppTheme.textColor)),
                          )),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        },
                      ),
                    ),
                  ],
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
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          );
        }

        if (provider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppTheme.accentColor.withOpacity(0.6),
                ),
                const SizedBox(height: 16),
                Text(
                  'Error: ${provider.error}',
                  style: const TextStyle(color: AppTheme.textColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => provider.loadFinancialLogs(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        var filteredLogs = provider.financialLogs;

        // Apply type filter
        if (_selectedFilter != 'all') {
          filteredLogs = filteredLogs.where((log) => log.type == _selectedFilter).toList();
        }

        // Apply category filter
        if (_selectedCategory != 'all') {
          filteredLogs = filteredLogs.where((log) => log.category == _selectedCategory).toList();
        }

        if (filteredLogs.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: AppTheme.secondaryColor,
                ),
                SizedBox(height: 16),
                Text(
                  'No logs match your filters',
                  style: TextStyle(
                    color: AppTheme.textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Try adjusting your filters',
                  style: TextStyle(color: AppTheme.textColor),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: filteredLogs.length,
          itemBuilder: (context, index) {
            final log = filteredLogs[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: log.type == 'income' 
                      ? AppTheme.primaryLight 
                      : AppTheme.accentLight,
                  child: Icon(
                    log.type == 'income' 
                        ? Icons.arrow_upward 
                        : Icons.arrow_downward,
                    color: log.type == 'income' 
                        ? AppTheme.primaryColor 
                        : AppTheme.accentColor,
                  ),
                ),
                title: Text(
                  log.description,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textColor,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${log.category} • ${log.date.day}/${log.date.month}/${log.date.year}',
                      style: const TextStyle(color: AppTheme.textColor),
                    ),
                    if (log.notes != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        log.notes!,
                        style: TextStyle(
                          color: AppTheme.textColor.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
                trailing: Text(
                  '${log.type == 'income' ? '+' : '-'}\$${log.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: log.type == 'income' 
                        ? AppTheme.primaryColor 
                        : AppTheme.accentColor,
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