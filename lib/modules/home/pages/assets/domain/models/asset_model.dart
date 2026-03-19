class AssetModel {
  final String? id;
  final String userId;
  final String name;
  final String type; // snake_case do name
  final int percentage;
  final double currentValue;
  final int score;
  final DateTime createdAt;
  final DateTime? updatedAt;

  AssetModel({
    this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.percentage,
    this.currentValue = 0.0,
    this.score = 0,
    required this.createdAt,
    this.updatedAt,
  });

  factory AssetModel.fromMap(Map<String, dynamic> map, String id) {
    return AssetModel(
      id: id,
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      percentage: (map['percentage'] ?? 0).toInt(),
      currentValue: (map['currentValue'] ?? 0.0).toDouble(),
      score: (map['score'] ?? 0).toInt(),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'type': type,
      'percentage': percentage,
      'currentValue': currentValue,
      'score': score,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  AssetModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? type,
    int? percentage,
    double? currentValue,
    int? score,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AssetModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      type: type ?? this.type,
      percentage: percentage ?? this.percentage,
      currentValue: currentValue ?? this.currentValue,
      score: score ?? this.score,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
