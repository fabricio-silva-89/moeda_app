class Asset {
  final String? id;
  final String userId;
  final String name;
  final String type; // snake_case do name
  final double percentage;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Asset({
    this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.percentage,
    required this.createdAt,
    this.updatedAt,
  });

  factory Asset.fromMap(Map<String, dynamic> map, String id) {
    return Asset(
      id: id,
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      percentage: (map['percentage'] ?? 0).toDouble(),
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
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Asset copyWith({
    String? id,
    String? userId,
    String? name,
    String? type,
    double? percentage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Asset(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      type: type ?? this.type,
      percentage: percentage ?? this.percentage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
