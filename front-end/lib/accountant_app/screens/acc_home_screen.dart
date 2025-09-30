// Complete code for lib/screens/accountant_home_screen.dart (Strictly Themed, No Provider)

import 'package:flutter/material.dart';

// Your project's local imports
import '../services/accountant_service.dart';
import '../models/financial_log.dart';
import '../models/invoice.dart';
import '../theme/app_theme.dart';
import 'maintain_financial_log_screen.dart';
import 'track_financial_logs_screen.dart';
import 'generate_invoice_screen.dart';
import 'send_invoice_screen.dart';
import 'verify_payment_screen.dart';
import 'preview_pdf_screen.dart';

class AccountantHomeScreen extends StatefulWidget {
  const AccountantHomeScreen({Key? key}) : super(key: key);

  @override
  State<AccountantHomeScreen> createState() => _AccountantHomeScreenState();
}

class _AccountantHomeScreenState extends State<AccountantHomeScreen> {
  // Local state variables to hold all the data
  bool _isLoading = true;
  String? _error;
  double _totalIncome = 0.0;
  double _totalExpenses = 0.0;
  double _pendingInvoicesAmount = 0.0;
  double get _netProfit => _totalIncome - _totalExpenses;
  List<FinancialLog> _financialLogs = [];
  List<Invoice> _invoices = [];

  final AccountantService _accountantService = AccountantService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final summaryFuture = _accountantService.getFinancialSummary();
      final logsFuture = _accountantService.getFinancialLogs();
      final invoicesFuture = _accountantService.getInvoices();

      final results = await Future.wait([summaryFuture, logsFuture, invoicesFuture]);
      
      final summaryData = results[0] as Map<String, dynamic>;
      final logsData = results[1] as List<FinancialLog>;
      final invoicesData = results[2] as List<Invoice>;
      
      if (!mounted) return;
      setState(() {
        _totalIncome = double.tryParse(summaryData['totalIncome'].toString()) ?? 0.0;
        _totalExpenses = double.tryParse(summaryData['totalExpenses'].toString()) ?? 0.0;
        _pendingInvoicesAmount = double.tryParse(summaryData['pendingInvoicesAmount'].toString()) ?? 0.0;
        _financialLogs = logsData;
        _invoices = invoicesData;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.themeData,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Accountant Dashboard'),
          backgroundColor: AppTheme.primaryColor,
        ),
        drawer: _buildNavigationDrawer(context),
        body: Container(
          color: AppTheme.backgroundColor,
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor));
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: AppTheme.accentColor, size: 60),
              const SizedBox(height: 16),
              Text(
                'Failed to Load Dashboard',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppTheme.textColor),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadData,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(),
            const SizedBox(height: 20),
            _buildFinancialOverview(),
            const SizedBox(height: 20),
            _buildQuickActions(),
            const SizedBox(height: 20),
            _buildRecentActivity(),
          ],
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
                  backgroundColor: AppTheme.backgroundColor,
                  child: Icon(Icons.person, size: 30, color: AppTheme.primaryColor),
                ),
                SizedBox(height: 10),
                Text(
                  'Accountant User',
                  style: TextStyle(
                    color: AppTheme.backgroundColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard, color: AppTheme.textColor),
            title: const Text('Dashboard', style: TextStyle(color: AppTheme.textColor)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet, color: AppTheme.textColor),
            title: const Text('Maintain Financial Logs', style: TextStyle(color: AppTheme.textColor)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MaintainFinancialLogScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.analytics, color: AppTheme.textColor),
            title: const Text('Track Financial Logs', style: TextStyle(color: AppTheme.textColor)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const TrackFinancialLogsScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long, color: AppTheme.textColor),
            title: const Text('Generate Invoice', style: TextStyle(color: AppTheme.textColor)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const GenerateInvoiceScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.preview, color: AppTheme.textColor),
            title: const Text('Preview PDF', style: TextStyle(color: AppTheme.textColor)),
            onTap: () {
              Navigator.pop(context);
              _showPreviewPdfDialog(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.send, color: AppTheme.textColor),
            title: const Text('Send Invoice', style: TextStyle(color: AppTheme.textColor)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SendInvoiceScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.verified, color: AppTheme.textColor),
            title: const Text('Verify Payment', style: TextStyle(color: AppTheme.textColor)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const VerifyPaymentScreen()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: AppTheme.textColor),
            title: const Text('Sign Out', style: TextStyle(color: AppTheme.textColor)),
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
    final availableInvoices = _invoices;
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
                subtitle: Text('₹${invoice.amount.toStringAsFixed(2)}'),
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
      )
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 8,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Welcome Back!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textLightColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Manage your finances efficiently',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textLightColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Financial Overview',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textColor),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildOverviewCard(
                'Total Income',
                '₹${_totalIncome.toStringAsFixed(2)}',
                Icons.trending_up,
                AppTheme.backgroundColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildOverviewCard(
                'Total Expenses',
                '₹${_totalExpenses.toStringAsFixed(2)}',
                Icons.trending_down,
                AppTheme.backgroundColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildOverviewCard(
                'Net Profit',
                '₹${_netProfit.toStringAsFixed(2)}',
                Icons.account_balance,
                AppTheme.backgroundColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildOverviewCard(
                'Pending Invoices',
                '₹${_pendingInvoicesAmount.toStringAsFixed(2)}',
                Icons.pending_actions,
                AppTheme.backgroundColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOverviewCard(String title, String amount, IconData icon, Color iconColor) {
    return Card(
      color: AppTheme.secondaryColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: iconColor, size: 24),
                Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textLightColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textLightColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textColor),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _buildActionCard(
              'Add Financial Log',
              Icons.add_circle,
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MaintainFinancialLogScreen())),
            ),
            _buildActionCard(
              'Generate Invoice',
              Icons.receipt_long,
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GenerateInvoiceScreen())),
            ),
            _buildActionCard(
              'Track Finances',
              Icons.analytics,
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TrackFinancialLogsScreen())),
            ),
            _buildActionCard(
              'Send Invoice',
              Icons.send,
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SendInvoiceScreen())),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, VoidCallback onTap) {
    return Card(
      color: AppTheme.secondaryColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: AppTheme.backgroundColor),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.backgroundColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    final recentLogs = _financialLogs.take(5).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Activity',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textColor),
        ),
        const SizedBox(height: 12),
        if (recentLogs.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: const [
                    Icon(Icons.inbox, size: 48, color: AppTheme.accentColor),
                    SizedBox(height: 8),
                    Text('No recent activity', style: TextStyle(color: AppTheme.textColor)),
                  ],
                ),
              ),
            ),
          )
        else
          ...recentLogs.map((log) {
            final bool isIncome = log.type == 'Income';
            return Card(
              color: AppTheme.secondaryColor,
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppTheme.accentLight,
                  child: Icon(
                    isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                    color: AppTheme.backgroundColor,
                  ),
                ),
                title: Text(
                  log.description,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textLightColor,
                  ),
                ),
                subtitle: Text(
                  '${log.category ?? "N/A"} • ${log.createdAt.day}/${log.createdAt.month}/${log.createdAt.year}',
                  style: const TextStyle(color: AppTheme.textLightColor),
                ),
                trailing: Text(
                  '${isIncome ? '+' : '-'}'
                  '₹${log.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isIncome ? AppTheme.successColor : AppTheme.errorColor,
                  ),
                ),
              ),
            );
          }).toList(),
      ],
    );
  }
}