import 'package:flutter/material.dart';

// Your project's local imports
import '../models/invoice.dart';
import '../theme/app_theme.dart';
import 'acc_home_screen.dart';
import 'maintain_financial_log_screen.dart';
import 'track_financial_logs_screen.dart';
import 'generate_invoice_screen.dart';
import 'send_invoice_screen.dart';
import 'verify_payment_screen.dart';

class PreviewPdfScreen extends StatelessWidget {
  final Invoice invoice;

  const PreviewPdfScreen({Key? key, required this.invoice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.themeData,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Preview Invoice'),
          backgroundColor: AppTheme.primaryColor,
        ),
        drawer: _buildNavigationDrawer(context),
        body: Container(
          color: AppTheme.backgroundColor,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 16),
                    _buildClientDetails(),
                    const SizedBox(height: 16),
                    _buildInvoiceDetails(),
                    const SizedBox(height: 24),
                    // REMOVED: _buildNotes() call as the field no longer exists
                    _buildActions(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationDrawer(BuildContext context) {
    // This navigation drawer is for context, no changes needed here.
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

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Invoice',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        Text(
          'ID: ${invoice.id}',
          style: const TextStyle(
            fontSize: 16,
            color: AppTheme.textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildClientDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Client Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Name: ${invoice.clientName}',
          style: const TextStyle(color: AppTheme.textColor),
        ),
        Text(
          'Email: ${invoice.clientEmail}',
          style: const TextStyle(color: AppTheme.textColor),
        ),
        // REMOVED: Text widget for clientAddress as it no longer exists.
      ],
    );
  }

  Widget _buildInvoiceDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Invoice Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        const SizedBox(height: 8),
        // REMOVED: Text widget for description as it no longer exists.
        Text(
          // CORRECTED: Currency symbol changed from $ to ₹
          'Amount: ₹${invoice.amount.toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        // ADDED: Null check for dueDate
        Text(
          invoice.dueDate != null
              ? 'Due Date: ${invoice.dueDate!.day}/${invoice.dueDate!.month}/${invoice.dueDate!.year}'
              : 'Due Date: N/A',
          style: const TextStyle(color: AppTheme.textColor),
        ),
        const SizedBox(height: 4),
        Text(
          // RENAMED: from createdDate to invoiceDate
          'Invoice Date: ${invoice.invoiceDate.day}/${invoice.invoiceDate.month}/${invoice.invoiceDate.year}',
          style: const TextStyle(color: AppTheme.textColor),
        ),
        const SizedBox(height: 4),
        Text(
          'Status: ${invoice.status}',
          style: TextStyle(
            // CORRECTED: Status checks are now Title Case to match the enum
            color: invoice.status == 'Paid'
                ? Colors.green.shade700
                : invoice.status == 'Overdue'
                    ? AppTheme.accentColor
                    : AppTheme.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // REMOVED: The entire _buildNotes widget as the field no longer exists.

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // CORRECTED: Status check is now 'Draft' (Title Case)
        if (invoice.status == 'Draft')
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  // You might want to pass the invoice object to the SendInvoiceScreen
                  builder: (context) => const SendInvoiceScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentColor),
            child: const Text('Send'),
          ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
          child: const Text('Close'),
        ),
      ],
    );
  }
}