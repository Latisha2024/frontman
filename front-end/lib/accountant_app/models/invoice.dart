class InvoiceItem {
  final String description;
  final int quantity;
  final double unitPrice;
  final double totalAmount;

  InvoiceItem({
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.totalAmount,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      description: json['description'],
      quantity: json['quantity'],
      unitPrice: json['unitPrice'].toDouble(),
      totalAmount: json['total'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'total': totalAmount,
    };
  }
}

class Invoice {
  final String id;
  final String clientName;
  final String clientEmail;
  final String? clientAddress;
  final String description;
  final double amount;
  final DateTime dueDate;
  final DateTime createdDate;
  String status; // 'draft', 'sent', 'paid', 'overdue'
  final String? notes;

  Invoice({
    required this.id,
    required this.clientName,
    required this.clientEmail,
    this.clientAddress,
    required this.description,
    required this.amount,
    required this.dueDate,
    required this.createdDate,
    this.status = 'draft',
    this.notes,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      clientName: json['clientName'],
      clientEmail: json['clientEmail'],
      clientAddress: json['clientAddress'],
      description: json['description'],
      amount: json['amount'].toDouble(),
      dueDate: DateTime.parse(json['dueDate']),
      createdDate: DateTime.parse(json['createdDate']),
      status: json['status'] ?? 'draft',
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientName': clientName,
      'clientEmail': clientEmail,
      'clientAddress': clientAddress,
      'description': description,
      'amount': amount,
      'dueDate': dueDate.toIso8601String(),
      'createdDate': createdDate.toIso8601String(),
      'status': status,
      'notes': notes,
    };
  }
}
