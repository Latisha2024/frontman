import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../sales_manager/screens/sales_manager_drawer.dart';
import '../controllers/order_summary.dart';
import 'admin_drawer.dart';

class OrderSummaryScreen extends StatefulWidget {
  final String role;
  const OrderSummaryScreen({super.key, required this.role});

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  late AdminOrderSummaryController controller;

  @override
  void initState() {
    super.initState();
    controller = AdminOrderSummaryController();
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
              'Order Summary',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: AppColors.primaryBlue,
            elevation: 0,
          ),
          drawer: widget.role == "admin" ? AdminDrawer() : SalesManagerDrawer(),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                buildSearchAndFilter(),
                const SizedBox(height: 20),
                Expanded(
                  child: controller.filteredOrders.isEmpty
                      ? const Center(child: Text('No orders found.'))
                      : ListView.builder(
                          itemCount: controller.filteredOrders.length,
                          itemBuilder: (context, index) {
                            final order = controller.filteredOrders[index];
                            return buildOrderCard(order);
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

  Widget buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundGray,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            onChanged: controller.searchOrders,
            decoration: InputDecoration(
              hintText: 'Search orders by ID or customer...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.textPrimary),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.textPrimary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.textPrimary),
              ),
              filled: true,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: controller.selectedStatus,
                    items: controller.availableStatuses.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(
                          status == 'All' ? 'All' : status,
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      if (newValue != null) controller.filterByStatus(newValue);
                    },
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      labelStyle: TextStyle(color: AppColors.textPrimary, fontSize: 12),
                    ),
                    dropdownColor: Colors.white,
                    style: const TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildOrderCard(OrderSummary order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.backgroundGray.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.receipt_long, color: AppColors.secondaryBlue, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.id,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        order.customer,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                buildStatusChip(order.status),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                buildInfoChip(Icons.calendar_today, 'Date', '${order.date.year}-${order.date.month.toString().padLeft(2, '0')}-${order.date.day.toString().padLeft(2, '0')}'),
                const SizedBox(width: 8),
                buildInfoChip(Icons.attach_money, 'Total', order.total.toStringAsFixed(2)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoChip(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.secondaryBlue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.secondaryBlue),
          const SizedBox(width: 4),
          Text('$label: $value', style: const TextStyle(fontSize: 13, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'Completed':
        color = AppColors.success;
        break;
      case 'Pending':
        color = AppColors.warning;
        break;
      case 'Cancelled':
        color = AppColors.error;
        break;
      default:
        color = AppColors.textSecondary;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
} 