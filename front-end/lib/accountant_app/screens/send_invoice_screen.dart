import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/accountant_provider.dart';
import '../theme/app_theme.dart';
import 'acc_home_screen.dart';
import 'maintain_financial_log_screen.dart';
import 'track_financial_logs_screen.dart';
import 'generate_invoice_screen.dart';
import 'verify_payment_screen.dart';
import 'preview_pdf_screen.dart';

class SendInvoiceScreen extends StatefulWidget {
  const SendInvoiceScreen({Key? key}) : super(key: key);

  @override
  State<SendInvoiceScreen> createState() => _SendInvoiceScreenState();
}

class _SendInvoiceScreenState extends State<SendInvoiceScreen> {
  final _emailController = TextEditingController();
  String? _selectedInvoiceId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountantProvider>().loadInvoices();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.themeData,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Send Invoice'),
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
                _buildSendInvoiceForm(),
                const SizedBox(height: 24),
                _buildInvoicesList(),
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

  Widget _buildSendInvoiceForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Send Invoice',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 16),
            Consumer<AccountantProvider>(
              builder: (context, provider, child) {
                final availableInvoices = provider.invoices
                    .where((invoice) => invoice.status == 'draft')
                    .toList();

                if (availableInvoices.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'No draft invoices available to send',
                        style: TextStyle(color: AppTheme.textColor),
                      ),
                    ),
                  );
                }

                return DropdownButtonFormField<String>(
                  value: _selectedInvoiceId,
                  decoration: const InputDecoration(
                    labelText: 'Select Invoice',
                    prefixIcon: Icon(Icons.receipt, color: AppTheme.accentColor),
                  ),
                  items: availableInvoices.map((invoice) {
                    return DropdownMenuItem(
                      value: invoice.id,
                      child: Text(
                        '${invoice.clientName} - \$${invoice.amount.toStringAsFixed(2)}',
                        style: const TextStyle(color: AppTheme.textColor),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedInvoiceId = value;
                      if (value != null) {
                        final selectedInvoice = availableInvoices
                            .firstWhere((invoice) => invoice.id == value);
                        _emailController.text = selectedInvoice.clientEmail;
                      }
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                prefixIcon: Icon(Icons.email, color: AppTheme.accentColor),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _selectedInvoiceId != null ? _sendInvoice : null,
                icon: const Icon(Icons.send),
                label: const Text('Send Invoice'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoicesList() {
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
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.secondaryColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'No sent invoices available',
                style: TextStyle(color: AppTheme.textColor),
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sent Invoices',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sentInvoices.length,
              itemBuilder: (context, index) {
                final invoice = sentInvoices[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppTheme.primaryLight,
                      child: Text(
                        invoice.clientName[0].toUpperCase(),
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      invoice.clientName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textColor,
                      ),
                    ),
                    subtitle: Text(
                      'Amount: \$${invoice.amount.toStringAsFixed(2)}',
                      style: const TextStyle(color: AppTheme.textColor),
                    ),
                    trailing: Text(
                      '${invoice.dueDate.day}/${invoice.dueDate.month}/${invoice.dueDate.year}',
                      style: const TextStyle(
                        color: AppTheme.textColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _sendInvoice() {
    if (_emailController.text.isEmpty || _selectedInvoiceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an invoice and enter an email address'),
          backgroundColor: AppTheme.accentColor,
        ),
      );
      return;
    }

    context.read<AccountantProvider>().sendInvoice(_selectedInvoiceId!, _emailController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invoice sent successfully!'),
        backgroundColor: AppTheme.accentColor,
      ),
    );
    setState(() {
      _selectedInvoiceId = null;
      _emailController.clear();
    });
  }
}
