enum TransactionType {
  contribution('Contribuição'),
  rebalance('Rebalanceamento'),
  dividend('Dividendo'),
  saleStock('Venda de Ação');

  final String displayName;
  const TransactionType(this.displayName);
}

class Transaction {
  final String id;
  final String userId;
  final TransactionType type;
  final String investmentType;
  final String? stockTicker;
  final double amount;
  final DateTime date;
  final String? notes;

  Transaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.investmentType,
    this.stockTicker,
    required this.amount,
    required this.date,
    this.notes,
  });

  factory Transaction.fromMap(Map<String, dynamic> map, String id) {
    return Transaction(
      id: id,
      userId: map['userId'] ?? '',
      type: TransactionType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => TransactionType.contribution,
      ),
      investmentType: map['investmentType'] ?? '',
      stockTicker: map['stockTicker'],
      amount: (map['amount'] ?? 0).toDouble(),
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type.name,
      'investmentType': investmentType,
      'stockTicker': stockTicker,
      'amount': amount,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

  Transaction copyWith({
    String? id,
    String? userId,
    TransactionType? type,
    String? investmentType,
    String? stockTicker,
    double? amount,
    DateTime? date,
    String? notes,
  }) {
    return Transaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      investmentType: investmentType ?? this.investmentType,
      stockTicker: stockTicker ?? this.stockTicker,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      notes: notes ?? this.notes,
    );
  }
}
