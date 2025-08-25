class WarrantyInfo {
  final String productId;
  final String serialNumber;
  final String purchaseDate;
  final String warrantyMonths;
  final String sellerId;

  WarrantyInfo({
    required this.productId,
    required this.serialNumber,
    required this.purchaseDate,
    required this.warrantyMonths,
    required this.sellerId,
  });

  factory WarrantyInfo.fromJson(Map<String, dynamic> json) {
    return WarrantyInfo(
      productId: json['productId'] ?? '',
      serialNumber: json['serialNumber'] ?? '',
      purchaseDate: json['purchaseDate'] ?? '',
      warrantyMonths: json['warrantyMonths']?.toString() ?? '',
      sellerId: json['sellerId'] ?? '',
    );
  }
}
