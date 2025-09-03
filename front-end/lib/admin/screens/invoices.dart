import '../../sales_manager/screens/sales_manager_drawer.dart';
import '../controllers/invoices.dart';
import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../widgets/invoice_list.dart';
import '../widgets/invoice_form.dart';
import 'admin_drawer.dart';

class AdminInvoicesScreen extends StatefulWidget {
  final String role;
  const AdminInvoicesScreen({super.key, required this.role});

  @override
  State<AdminInvoicesScreen> createState() => _AdminInvoicesScreenState();
}

class _AdminInvoicesScreenState extends State<AdminInvoicesScreen> {
  late AdminInvoicesController controller;
  // Read-only screen: no form toggle

  @override
  void initState() {
    super.initState();
    controller = AdminInvoicesController();
    // Load invoices from API on initialization
    _loadInvoices();
  }

  Future<void> _loadInvoices() async {
    await controller.fetchInvoices();
  }

  Future<void> _refreshInvoices() async {
    await controller.refreshInvoices();
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
        return Scaffold(
          appBar: AppBar(
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            title: const Text(
              'Invoices',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: AppColors.primaryBlue,
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: controller.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      )
                    : IconButton(
                        tooltip: 'Refresh',
                        onPressed: _refreshInvoices,
                        icon: const Icon(Icons.refresh, color: Colors.white),
                      ),
              ),
              IconButton(
                tooltip: 'Generate by Order ID',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => Scaffold(
                        appBar: AppBar(
                          title: const Text('Generate Invoice'),
                          backgroundColor: AppColors.primaryBlue,
                        ),
                        body: SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: InvoiceForm(controller: controller),
                        ),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),
          drawer: widget.role == "admin" ? AdminDrawer() : SalesManagerDrawer(),
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              if (controller.error != null)
                SliverToBoxAdapter(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red.shade600),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            controller.error!,
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            controller.error = null;
                            controller.notifyListeners();
                          },
                          color: Colors.red.shade600,
                          iconSize: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              SliverToBoxAdapter(child: buildStatsHeader()),
            ],
            body: buildListView(),
          ),
        );
      },
    );
  }


  Widget buildStatsHeader() {
    double totalDue = controller.invoices.fold(0, (sum, inv) => sum + inv.totalDue);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundGray,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildStatCard(
                'Total Invoices',
                controller.invoices.length.toString(),
                Icons.receipt_long,
              ),
              buildStatCard(
                'Total Due',
                totalDue.toStringAsFixed(2),
                Icons.currency_rupee_rounded,
              ),
              buildStatCard(
                'Filtered',
                controller.filteredInvoices.length.toString(),
                Icons.filter_list,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.secondaryBlue.withOpacity(0.15),
        border: Border.all(color: AppColors.secondaryBlue.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListView() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: InvoiceList(
        controller: controller,
        onRefresh: _refreshInvoices,
      ),
    );
  }
}