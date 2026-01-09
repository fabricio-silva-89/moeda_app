enum InvestmentType {
  rendalixo('Renda Fixa'),
  fiis('FIIs'),
  acoes('Ações'),
  bdrs('BDRs');

  final String displayName;
  const InvestmentType(this.displayName);
}

class Investment {
  final String id;
  final String userId;
  final InvestmentType type;
  final double percentage;
  final double currentValue;
  final double initialValue;
  final DateTime createdAt;
  final DateTime updatedAt;

  Investment({
    required this.id,
    required this.userId,
    required this.type,
    required this.percentage,
    required this.currentValue,
    required this.initialValue,
    required this.createdAt,
    required this.updatedAt,
  });

  double get return_ => currentValue - initialValue;
  double get returnPercentage =>
      initialValue > 0 ? (return_ / initialValue) * 100 : 0;

  factory Investment.fromMap(Map<String, dynamic> map, String id) {
    return Investment(
      id: id,
      userId: map['userId'] ?? '',
      type: InvestmentType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => InvestmentType.rendalixo,
      ),
      percentage: (map['percentage'] ?? 0).toDouble(),
      currentValue: (map['currentValue'] ?? 0).toDouble(),
      initialValue: (map['initialValue'] ?? 0).toDouble(),
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
      'type': type.name,
      'percentage': percentage,
      'currentValue': currentValue,
      'initialValue': initialValue,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Investment copyWith({
    String? id,
    String? userId,
    InvestmentType? type,
    double? percentage,
    double? currentValue,
    double? initialValue,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Investment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      percentage: percentage ?? this.percentage,
      currentValue: currentValue ?? this.currentValue,
      initialValue: initialValue ?? this.initialValue,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
