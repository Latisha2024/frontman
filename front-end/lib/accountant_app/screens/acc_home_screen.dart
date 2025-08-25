import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/accountant_provider.dart';
import '../theme/app_theme.dart';
import 'maintain_financial_log_screen.dart';
import 'track_financial_logs_screen.dart';
import 'generate_invoice_screen.dart';
import 'send_invoice_screen.dart';
import 'verify_payment_screen.dart';
import 'preview_pdf_screen.dart';
import '../models/invoice.dart';

class AccountantHomeScreen extends StatefulWidget {
  const AccountantHomeScreen({Key? key}) : super(key: key);

  @override
  State<AccountantHomeScreen> createState() => _AccountantHomeScreenState();
}

class _AccountantHomeScreenState extends State<AccountantHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountantProvider>().loadFinancialLogs();
      context.read<AccountantProvider>().loadInvoices();
    });
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
          child: SingleChildScrollView(
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

  Widget _buildWelcomeCard() {
    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
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
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Manage your finances efficiently',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialOverview() {
    return Consumer<AccountantProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Financial Overview',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildOverviewCard(
                    'Total Income',
                    '\$${provider.totalIncome.toStringAsFixed(2)}',
                    Icons.trending_up,
                    AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildOverviewCard(
                    'Total Expenses',
                    '\$${provider.totalExpenses.toStringAsFixed(2)}',
                    Icons.trending_down,
                    AppTheme.accentColor,
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
                    '\$${provider.netProfit.toStringAsFixed(2)}',
                    Icons.account_balance,
                    provider.netProfit >= 0 ? AppTheme.primaryColor : AppTheme.accentColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildOverviewCard(
                    'Pending Invoices',
                    '\$${provider.pendingInvoicesAmount.toStringAsFixed(2)}',
                    Icons.pending_actions,
                    AppTheme.accentColor,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildOverviewCard(String title, String amount, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Text(
                  amount,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textColor,
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
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
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
              AppTheme.primaryColor,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MaintainFinancialLogScreen(),
                ),
              ),
            ),
            _buildActionCard(
              'Generate Invoice',
              Icons.receipt_long,
              AppTheme.secondaryColor,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GenerateInvoiceScreen(),
                ),
              ),
            ),
            _buildActionCard(
              'Track Finances',
              Icons.analytics,
              AppTheme.accentColor,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TrackFinancialLogsScreen(),
                ),
              ),
            ),
            _buildActionCard(
              'Send Invoice',
              Icons.send,
              AppTheme.primaryDark,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SendInvoiceScreen(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Consumer<AccountantProvider>(
      builder: (context, provider, child) {
        final recentLogs = provider.financialLogs.take(5).toList();
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 12),
            if (recentLogs.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      children: const [
                        Icon(
                          Icons.inbox,
                          size: 48,
                          color: AppTheme.accentColor,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'No recent activity',
                          style: TextStyle(color: AppTheme.textColor),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              ...recentLogs.map((log) => Card(
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
                  subtitle: Text(
                    '${log.category} • ${log.date.day}/${log.date.month}/${log.date.year}',
                    style: const TextStyle(color: AppTheme.textColor),
                  ),
                  trailing: Text(
                    '${log.type == 'income' ? '+' : '-'}\$${log.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: log.type == 'income' 
                          ? AppTheme.primaryColor 
                          : AppTheme.accentColor,
                    ),
                  ),
                ),
              )).toList(),
          ],
        );
      },
    );
  }
}
