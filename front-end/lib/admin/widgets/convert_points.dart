import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../controllers/convert_points.dart';

class ConvertPointsToCashForm extends StatefulWidget {
  final AdminConvertPointsController controller;
  const ConvertPointsToCashForm({super.key, required this.controller});

  @override
  State<ConvertPointsToCashForm> createState() => _ConvertPointsToCashFormState();
}

class _ConvertPointsToCashFormState extends State<ConvertPointsToCashForm> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _txnSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _txnSearchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        return Column(
          children: [
            // Tab Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: AppColors.primaryBlue,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppColors.primaryBlue,
                tabs: const [
                  Tab(text: 'Adjust Points', icon: Icon(Icons.edit)),
                  Tab(text: 'Convert Points', icon: Icon(Icons.currency_exchange)),
                  Tab(text: 'Transactions', icon: Icon(Icons.list)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAdjustPointsTab(),
                  _buildConvertPointsTab(),
                  _buildTransactionsTab(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAdjustPointsTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.controller.error != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.controller.error!,
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                  ),
                ],
              ),
            ),
          if (widget.controller.successMessage != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.controller.successMessage!,
                      style: TextStyle(color: Colors.green.shade700),
                    ),
                  ),
                ],
              ),
            ),
          // User ID Field
          _buildTextField(
            controller: widget.controller.userIdController,
            label: 'User Name',
            icon: Icons.person,
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                if (widget.controller.userIdController.text.trim().isNotEmpty) {
                  widget.controller.fetchUserPoints(widget.controller.userIdController.text.trim());
                }
              },
            ),
          ),
          const SizedBox(height: 16),
          // Show user's current points
          if (widget.controller.userTotalPoints != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.account_balance_wallet, color: AppColors.primaryBlue),
                  const SizedBox(width: 8),
                  Text(
                    'Current Points: ${widget.controller.userTotalPoints}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          // Points to adjust
          _buildTextField(
            controller: widget.controller.pointsController,
            label: 'Points to Adjust (+ or -)',
            icon: Icons.add_circle,
            keyboardType: TextInputType.number,
            hintText: 'Enter positive or negative number',
          ),
          const SizedBox(height: 16),
          // Reason
          _buildTextField(
            controller: widget.controller.reasonController,
            label: 'Reason for Adjustment',
            icon: Icons.note,
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          // Adjust Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: widget.controller.isLoading ? null : widget.controller.adjustPoints,
            child: widget.controller.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('Adjust Points', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildConvertPointsTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // User ID Field
          _buildTextField(
            controller: widget.controller.userIdController,
            label: 'User Name',
            icon: Icons.person,
          ),
          const SizedBox(height: 16),
          // Points to convert
          _buildTextField(
            controller: widget.controller.pointsController,
            label: 'Points to Convert',
            icon: Icons.currency_exchange,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          // Conversion rate
          _buildTextField(
            controller: widget.controller.conversionRateController,
            label: 'Conversion Rate (e.g., 0.01)',
            icon: Icons.percent,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            hintText: 'Enter positive decimal rate',
          ),
          const SizedBox(height: 16),
          // Reason (optional)
          _buildTextField(
            controller: widget.controller.reasonController,
            label: 'Reason (optional)',
            icon: Icons.note,
            maxLines: 2,
          ),
          const SizedBox(height: 24),
          // Convert Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonPrimary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: widget.controller.isLoading ? null : widget.controller.convertPointsToCash,
            child: widget.controller.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('Convert to Cash', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 24),
          // Conversion Result
          if (widget.controller.convertedAmount != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade300),
              ),
              child: Column(
                children: [
                  Icon(Icons.monetization_on, color: Colors.green.shade600, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    'Converted Amount',
                    style: TextStyle(fontSize: 14, color: Colors.green.shade700),
                  ),
                  Text(
                    '₹${widget.controller.convertedAmount!.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTransactionsTab() {
    return Column(
      children: [
        // Search and type filter
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _txnSearchController,
                label: 'Search by user, ID, reason, or type',
                icon: Icons.search,
                onChanged: (value) {
                  widget.controller.searchTransactions(value);
                },
              ),
            ),
            const SizedBox(width: 8),
            DropdownButton<String>(
              hint: const Text('Type'),
              items: ['All', 'Adjusted', 'Claimed', 'Earned'].map((type) {
                return DropdownMenuItem(
                  value: type == 'All' ? null : type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (type) {
                widget.controller.fetchAllTransactions(type: type);
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Transactions List
        Expanded(
          child: widget.controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : widget.controller.filteredTransactions.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No transactions found',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: widget.controller.filteredTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction = widget.controller.filteredTransactions[index];
                        return _buildTransactionCard(transaction);
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildTransactionCard(PointTransaction transaction) {
    final isPositive = transaction.points > 0;
    final color = isPositive ? Colors.green : Colors.red;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(
            isPositive ? Icons.add : Icons.remove,
            color: color,
          ),
        ),
        title: Text(
          '${isPositive ? '+' : ''}${transaction.points} points',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User: ${transaction.user?['name'] ?? transaction.userId}'),
            Text('Reason: ${transaction.reason}'),
            Text('Type: ${transaction.type}'),
          ],
        ),
        trailing: Text(
          '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? hintText,
    Widget? suffixIcon,
    Function(String)? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          prefixIcon: Icon(icon, color: AppColors.primaryBlue),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          labelStyle: const TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}