class FinancialLog {
  final String id;
  final String description;
  final double amount;
  final String type; // 'income' or 'expense'
  final String category;
  final DateTime date;
  final String? notes;

  FinancialLog({
    required this.id,
    required this.description,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'type': type,
      'category': category,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

  factory FinancialLog.fromJson(Map<String, dynamic> json) {
    return FinancialLog(
      id: json['id'],
      description: json['description'],
      amount: json['amount'].toDouble(),
      type: json['type'],
      category: json['category'],
      date: DateTime.parse(json['date']),
      notes: json['notes'],
    );
  }
}