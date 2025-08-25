import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class AddFollowUpPage extends StatelessWidget {
  const AddFollowUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Pre-filled demo data
    final TextEditingController customerController = TextEditingController(text: 'Priya Sharma');
    final TextEditingController followUpDetailsController = TextEditingController(
      text: 'Wants to reschedule delivery for next Monday',
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        title: const Text('Add Follow-Up'),
      ),
      body: Container(
        color: AppColors.backgroundGray,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Recent Follow-Ups',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildFollowUpCard('John Doe', 'Pending payment confirmation', '2:28'),
              _buildFollowUpCard('Ayesha', 'Requested delivery status update', '2:28'),
              _buildFollowUpCard('Ravi Kumar', 'Needs rescheduling of visit', '2:28'),
              const SizedBox(height: 24),

              _buildFormCard(
                icon: Icons.person,
                label: 'Customer Name',
                controller: customerController,
                hintText: 'Enter customer name',
              ),
              const SizedBox(height: 16),
              _buildFormCard(
                icon: Icons.description,
                label: 'Follow-Up Details',
                controller: followUpDetailsController,
                hintText: 'Enter follow-up details',
                maxLines: 5,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Save Follow-Up'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    final customer = customerController.text.trim();
                    final followUpDetails = followUpDetailsController.text.trim();
                    if (customer.isNotEmpty && followUpDetails.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Follow-up saved successfully!')),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill in all fields')),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primaryBlue),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: maxLines,
              decoration: InputDecoration(
                hintText: hintText,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFollowUpCard(String name, String details, String time) {
    return Card(
      color: Colors.purple.shade50,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.person_pin_circle, color: Colors.purple),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(details),
        trailing: Text('Updated: $time', style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ),
    );
  }
}
