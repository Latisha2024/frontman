import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../controllers/warranty_database.dart';

class WarrantyList extends StatefulWidget {
  final AdminWarrantyDatabaseController controller;
  final Future<void> Function()? onRefresh;
  const WarrantyList({super.key, required this.controller, this.onRefresh});

  @override
  State<WarrantyList> createState() => _WarrantyListState();
}

class _WarrantyListState extends State<WarrantyList> {
  final TextEditingController _idController = TextEditingController();
  bool _fetchingById = false;

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  Future<void> _showDetailsDialog(Warranty warranty) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Warranty Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID: ${warranty.id}'),
              const SizedBox(height: 6),
              Text('Product: ${warranty.product}'),
              const SizedBox(height: 6),
              Text('Customer: ${warranty.customer}'),
              const SizedBox(height: 6),
              Text('Serial: ${warranty.serialNumber}'),
              const SizedBox(height: 6),
              Text('Purchase: ${warranty.purchaseDate.toIso8601String().split('T').first}'),
              const SizedBox(height: 6),
              Text('Expiry: ${warranty.expiryDate.toIso8601String().split('T').first}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            )
          ],
        );
      },
    );
  }

  Future<void> _fetchById() async {
    final id = _idController.text.trim();
    if (id.isEmpty) return;
    setState(() => _fetchingById = true);
    final warranty = await widget.controller.fetchWarrantyCardById(id);
    setState(() => _fetchingById = false);
    if (warranty != null && mounted) {
      _showDetailsDialog(warranty);
    } else if (mounted && widget.controller.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.controller.error!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
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
        const SizedBox(height: 12),
        // Find by ID row
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _idController,
                decoration: InputDecoration(
                  hintText: 'Enter warranty ID...',
                  prefixIcon: const Icon(Icons.badge),
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
                onSubmitted: (_) => _fetchById(),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: _fetchingById ? null : _fetchById,
              icon: _fetchingById
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.search),
              label: const Text('Get Details'),
            )
          ],
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
                      onRefresh: widget.onRefresh ?? () async {},
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: controller.filteredWarranties.length,
                        itemBuilder: (context, index) {
                          final warranty = controller.filteredWarranties[index];
                          return InkWell(
                            onTap: () async {
                              final w = await controller.fetchWarrantyCardById(warranty.id);
                              if (!mounted) return;
                              if (w != null) {
                                _showDetailsDialog(w);
                              } else if (controller.error != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(controller.error!)),
                                );
                              }
                            },
                            child: Container(
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
                            ),
                          );
                        },
                      ),
                    ),
        ),
      ],
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