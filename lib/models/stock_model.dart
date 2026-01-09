class Stock {
  final String id;
  final String userId;
  final String ticker;
  final String name;
  final String sector;
  final bool isPreferred;
  final double averageCost;
  final double currentPrice;
  final int quantity;
  final double percentage;
  final DateTime createdAt;
  final DateTime updatedAt;

  Stock({
    required this.id,
    required this.userId,
    required this.ticker,
    required this.name,
    required this.sector,
    required this.isPreferred,
    required this.averageCost,
    required this.currentPrice,
    required this.quantity,
    required this.percentage,
    required this.createdAt,
    required this.updatedAt,
  });

  double get totalCost => averageCost * quantity;
  double get totalCurrentValue => currentPrice * quantity;
  double get return_ => totalCurrentValue - totalCost;
  double get returnPercentage =>
      totalCost > 0 ? (return_ / totalCost) * 100 : 0;
  double get dailyVariation =>
      totalCost > 0 ? ((currentPrice - averageCost) / averageCost) * 100 : 0;

  factory Stock.fromMap(Map<String, dynamic> map, String id) {
    return Stock(
      id: id,
      userId: map['userId'] ?? '',
      ticker: map['ticker'] ?? '',
      name: map['name'] ?? '',
      sector: map['sector'] ?? '',
      isPreferred: map['isPreferred'] ?? false,
      averageCost: (map['averageCost'] ?? 0).toDouble(),
      currentPrice: (map['currentPrice'] ?? 0).toDouble(),
      quantity: (map['quantity'] ?? 0).toInt(),
      percentage: (map['percentage'] ?? 0).toDouble(),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'ticker': ticker,
      'name': name,
      'sector': sector,
      'isPreferred': isPreferred,
      'averageCost': averageCost,
      'currentPrice': currentPrice,
      'quantity': quantity,
      'percentage': percentage,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Stock copyWith({
    String? id,
    String? userId,
    String? ticker,
    String? name,
    String? sector,
    bool? isPreferred,
    double? averageCost,
    double? currentPrice,
    int? quantity,
    double? percentage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Stock(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      ticker: ticker ?? this.ticker,
      name: name ?? this.name,
      sector: sector ?? this.sector,
      isPreferred: isPreferred ?? this.isPreferred,
      averageCost: averageCost ?? this.averageCost,
      currentPrice: currentPrice ?? this.currentPrice,
      quantity: quantity ?? this.quantity,
      percentage: percentage ?? this.percentage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
