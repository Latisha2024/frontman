// models/financial_log.dart

class FinancialLog {
  final String? id;
  final String description;
  final double amount;
  final String type; // e.g., "Income", "Expense"
  final String? category;
  final DateTime createdAt;
  final String? reference;
  final String? createdBy;

  FinancialLog({
    this.id,
    required this.description,
    required this.amount,
    required this.type,
    this.category,
    required this.createdAt,
    this.reference,
    this.createdBy,
  });

  factory FinancialLog.fromJson(Map<String, dynamic> json) {
    // This part is for reading data and is already robust from our previous fixes.
    return FinancialLog(
      id: json['_id'] ?? json['id'],
      description: json['description'],
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      type: json['type'],
      category: json['category'],
      createdAt: DateTime.parse(json['createdAt']),
      reference: json['reference'],
      createdBy: json['createdByUser']?['name'],
    );
  }

  // THIS IS THE METHOD TO CHANGE
  Map<String, dynamic> toJson() {
    // This helper logic ensures the string is "Income" not "INCOME" or "income"
    String formattedType = type.isEmpty
        ? ''
        : '${type[0].toUpperCase()}${type.substring(1).toLowerCase()}';

    return {
      'description': description,
      'amount': amount,
      // CORRECTED: Send the type in the exact Title Case format the schema requires
      'type': formattedType,
      'category': category,
      'reference': reference,
    };
  }
}