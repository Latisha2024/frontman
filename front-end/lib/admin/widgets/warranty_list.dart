import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../controllers/warranty_database.dart';

class WarrantyList extends StatelessWidget {
  final AdminWarrantyDatabaseController controller;
  final Future<void> Function()? onRefresh;
  const WarrantyList({super.key, required this.controller, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        TextField(
          onChanged: controller.searchWarranties,
          decoration: InputDecoration(
            hintText: 'Search warranties by product, customer, or serial number...',
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
        // List with loading state
        Expanded(
          child: controller.isLoading
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading warranty cards...'),
                    ],
                  ),
                )
              : controller.filteredWarranties.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No warranty cards found',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try adjusting your search or refresh the list',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: onRefresh ?? () async {},
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: controller.filteredWarranties.length,
                        itemBuilder: (context, index) {
              final warranty = controller.filteredWarranties[index];
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
                          const Icon(Icons.verified_user, color: AppColors.secondaryBlue, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  warranty.product,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  'ID: ${warranty.id}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildInfoChip(Icons.confirmation_number, 'Serial', warranty.serialNumber),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              buildInfoChip(Icons.date_range, 'Purchase', '${warranty.purchaseDate.year}-${warranty.purchaseDate.month.toString().padLeft(2, '0')}-${warranty.purchaseDate.day.toString().padLeft(2, '0')}'),
                              const SizedBox(width: 8),
                              buildInfoChip(Icons.event, 'Expiry', '${warranty.expiryDate.year}-${warranty.expiryDate.month.toString().padLeft(2, '0')}-${warranty.expiryDate.day.toString().padLeft(2, '0')}'),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        )],
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
} 