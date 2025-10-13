import 'package:flutter/material.dart';
import '../controllers/invoices.dart';
import '../../constants/colors.dart';

class InvoiceDetailScreen extends StatefulWidget {
  final String invoiceId;
  const InvoiceDetailScreen({super.key, required this.invoiceId});

  @override
  State<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  late final AdminInvoicesController controller;

  @override
  void initState() {
    super.initState();
    controller = AdminInvoicesController();
    _load();
  }

  Future<void> _load() async {
    await controller.fetchInvoiceById(widget.invoiceId);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final invoice = controller.lastFetchedInvoice;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Invoice Details'),
            backgroundColor: AppColors.primaryBlue,
            actions: [
              IconButton(
                tooltip: 'Refresh',
                onPressed: _load,
                icon: const Icon(Icons.refresh),
              )
            ],
          ),
          body: controller.isLoading && invoice == null
              ? const Center(child: CircularProgressIndicator())
              : invoice == null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          controller.error ?? 'Invoice not found',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          // Summary
                          _section(
                            'Summary',
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _row('Invoice No.', invoice.invoiceNumber),
                                _row('Issue Date', _fmtDate(invoice.issueDate)),
                                _row('Due Date', _fmtDate(invoice.dueDate)),
                                _row('Reference', invoice.reference),
                                _row('Bill To', invoice.billTo),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Line Items
                          _section(
                            'Items',
                            Column(
                              children: [
                                for (final it in invoice.items)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 6),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                it.description,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text('Qty: ${it.quantity}  x  ${it.unitPrice.toStringAsFixed(2)}'),
                                              Text('GST: ${it.gstRate.toStringAsFixed(0)}%'),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          it.amount.toStringAsFixed(2),
                                          style: const TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Totals
                          _section(
                            'Totals',
                            Column(
                              children: [
                                _totalRow('Subtotal', invoice.subtotal),
                                _totalRow('GST Total', invoice.gstTotal),
                                const Divider(),
                                _totalRow('Total Due', invoice.totalDue, bold: true),
                              ],
                            ),
                          ),
                          if (controller.successMessage != null) ...[
                            const SizedBox(height: 12),
                            _info(controller.successMessage!, Colors.green),
                          ],
                          if (controller.error != null) ...[
                            const SizedBox(height: 12),
                            _info(controller.error!, Colors.red),
                          ],
                        ],
                      ),
                    ),
        );
      },
    );
  }

  Widget _section(String title, Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }

  Widget _row(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(k, style: const TextStyle(color: Colors.black54))),
          Expanded(child: Text(v, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _totalRow(String k, double v, {bool bold = false}) {
    final style = TextStyle(
      fontWeight: bold ? FontWeight.bold : FontWeight.w600,
      fontSize: bold ? 16 : 14,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(k, style: style.copyWith(color: Colors.black87))),
          Text(v.toStringAsFixed(2), style: style),
        ],
      ),
    );
  }

  String _fmtDate(DateTime d) => '${d.day}/${d.month}/${d.year}';

  Widget _info(String msg, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(color == Colors.red ? Icons.error_outline : Icons.check_circle_outline, color: color),
          const SizedBox(width: 8),
          Expanded(child: Text(msg, style: TextStyle(color: Colors.black))),
        ],
      ),
    );
  }
}
