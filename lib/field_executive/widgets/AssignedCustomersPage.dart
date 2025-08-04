import 'package:flutter/material.dart';
import '../../constants/colors.dart'; // Use your global theme colors if available

class AssignedCustomersPage extends StatelessWidget {
  const AssignedCustomersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final customers = [
      {
        "id": "CUST101",
        "name": "Dairybelle",
        "location": "Pinetown",
        "contact": "1234567890",
        "email": "dairy@example.com"
      },
      {
        "id": "CUST102",
        "name": "MilkMart",
        "location": "Durban",
        "contact": "9876543210",
        "email": "milk@example.com"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Assigned Customers"),
        backgroundColor: AppColors.primaryBlue,
      ),
      body: Container(
        color: Colors.grey.shade100,
        padding: const EdgeInsets.all(12),
        child: ListView.builder(
          itemCount: customers.length,
          itemBuilder: (context, index) {
            final customer = customers[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.person, size: 40, color: AppColors.primaryBlue),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            customer["name"] ?? '',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text("ID: ${customer["id"]}", style: const TextStyle(fontSize: 14)),
                          Text("Location: ${customer["location"]}", style: const TextStyle(fontSize: 14)),
                          Text("Contact: ${customer["contact"]}", style: const TextStyle(fontSize: 14)),
                          Text("Email: ${customer["email"]}", style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
