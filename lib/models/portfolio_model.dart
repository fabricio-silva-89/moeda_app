import 'investment_model.dart';

class Portfolio {
  final String id;
  final String userId;
  final double totalInvested;
  final double currentValue;
  final Map<InvestmentType, double> allocationPercentages;
  final DateTime createdAt;
  final DateTime updatedAt;

  Portfolio({
    required this.id,
    required this.userId,
    required this.totalInvested,
    required this.currentValue,
    required this.allocationPercentages,
    required this.createdAt,
    required this.updatedAt,
  });

  double get totalReturn => currentValue - totalInvested;
  double get returnPercentage =>
      totalInvested > 0 ? (totalReturn / totalInvested) * 100 : 0;

  factory Portfolio.fromMap(Map<String, dynamic> map, String id) {
    return Portfolio(
      id: id,
      userId: map['userId'] ?? '',
      totalInvested: (map['totalInvested'] ?? 0).toDouble(),
      currentValue: (map['currentValue'] ?? 0).toDouble(),
      allocationPercentages: _parseAllocationPercentages(map['allocationPercentages']),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : DateTime.now(),
    );
  }

  static Map<InvestmentType, double> _parseAllocationPercentages(
      dynamic data) {
    if (data == null) return {};
    final map = <InvestmentType, double>{};
    if (data is Map) {
      data.forEach((key, value) {
        final type = InvestmentType.values
            .firstWhere((e) => e.name == key, orElse: () => InvestmentType.rendalixo);
        map[type] = (value ?? 0).toDouble();
      });
    }
    return map;
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'totalInvested': totalInvested,
      'currentValue': currentValue,
      'allocationPercentages': allocationPercentages
          .map((key, value) => MapEntry(key.name, value)),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Portfolio copyWith({
    String? id,
    String? userId,
    double? totalInvested,
    double? currentValue,
    Map<InvestmentType, double>? allocationPercentages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Portfolio(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      totalInvested: totalInvested ?? this.totalInvested,
      currentValue: currentValue ?? this.currentValue,
      allocationPercentages:
          allocationPercentages ?? this.allocationPercentages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
