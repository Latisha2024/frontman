// lib/models/invoice.dart (Corrected)

class Invoice {
  final String id;
  String status;
  final double amount;
  final DateTime? dueDate;
  final DateTime invoiceDate;
  final String clientName;
  final String clientEmail;
  final String? userId;

  Invoice({
    required this.id,
    required this.status,
    required this.amount,
    this.dueDate,
    required this.invoiceDate,
    required this.clientName,
    required this.clientEmail,
    this.userId,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'] ?? json['_id'],
      status: json['status'],
      amount: double.tryParse(json['totalAmount'].toString()) ?? 0.0,
      dueDate: json['dueDate'] == null ? null : DateTime.parse(json['dueDate']),
      invoiceDate: DateTime.parse(json['invoiceDate']),
      clientName: json['order']?['user']?['name'] ?? 'N/A',
      clientEmail: json['order']?['user']?['email'] ?? 'N/A',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalAmount': amount,
      
      'dueDate': dueDate?.toIso8601String(),
      'userId': userId,
    };
  }
}