import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/accountant_provider.dart';
import '../theme/app_theme.dart';
import 'acc_home_screen.dart';
import 'maintain_financial_log_screen.dart';
import 'track_financial_logs_screen.dart';
import 'generate_invoice_screen.dart';
import 'send_invoice_screen.dart';
import 'preview_pdf_screen.dart';

class VerifyPaymentScreen extends StatefulWidget {
  const VerifyPaymentScreen({Key? key}) : super(key: key);

  @override
  State<VerifyPaymentScreen> createState() => _VerifyPaymentScreenState();
}

class _VerifyPaymentScreenState extends State<VerifyPaymentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountantProvider>().loadInvoices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.themeData,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Verify Payment'),
          backgroundColor: AppTheme.primaryColor,
        ),
        drawer: _buildNavigationDrawer(context),
        body: Container(
          color: AppTheme.backgroundColor,
          child: Consumer<AccountantProvider>(
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
                        onPressed: () => provider.loadInvoices(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              final sentInvoices = provider.invoices
                  .where((invoice) => invoice.status == 'sent')
                  .toList();

              if (sentInvoices.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.verified,
                        size: 64,
                        color: AppTheme.secondaryColor,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No sent invoices to verify',
                        style: TextStyle(
                          color: AppTheme.textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Send some invoices first',
                        style: TextStyle(color: AppTheme.textColor),
                      ),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sent Invoices Awaiting Payment',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: sentInvoices.length,
                      itemBuilder: (context, index) {
                        final invoice = sentInvoices[index];
                        final isOverdue = DateTime.now().isAfter(invoice.dueDate);
                        
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            invoice.clientName,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.textColor,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            invoice.clientEmail,
                                            style: const TextStyle(
                                              color: AppTheme.textColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isOverdue ? AppTheme.accentColor.withOpacity(0.2) : AppTheme.secondaryColor,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        isOverdue ? 'OVERDUE' : 'SENT',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: isOverdue ? AppTheme.accentColor : AppTheme.textColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  invoice.description,
                                  style: const TextStyle(
                                    color: AppTheme.textColor,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Amount:',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.textColor,
                                          ),
                                        ),
                                        Text(
                                          '\$${invoice.amount.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        const Text(
                                          'Due Date:',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.textColor,
                                          ),
                                        ),
                                        Text(
                                          '${invoice.dueDate.day}/${invoice.dueDate.month}/${invoice.dueDate.year}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: isOverdue ? AppTheme.accentColor : AppTheme.textColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () => _verifyPayment(invoice.id),
                                    icon: const Icon(Icons.check_circle),
                                    label: const Text('Mark as Paid'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.accentColor,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
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

  void _verifyPayment(String invoiceId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verify Payment'),
        content: const Text('Are you sure this invoice has been paid?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AccountantProvider>().verifyPayment(invoiceId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Payment verified successfully!'),
                  backgroundColor: AppTheme.accentColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentColor),
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }
}