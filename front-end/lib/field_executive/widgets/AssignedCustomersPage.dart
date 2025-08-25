import 'package:flutter/material.dart';
import '../../constants/colors.dart';

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
      {
        "id": "CUST103",
        "name": "Creamy Lane",
        "location": "Umhlanga",
        "contact": "9988776655",
        "email": "creamy@example.com"
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
                    const Icon(Icons.person_pin, size: 40, color: AppColors.primaryBlue),
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
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  // Add call logic or link with dialer
                                },
                                icon: const Icon(Icons.phone),
                                label: const Text("Call"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton.icon(
                                onPressed: () {
                                  // Add email logic or mailto:
                                },
                                icon: const Icon(Icons.email),
                                label: const Text("Email"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueGrey,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          )
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
