class CreateUserAssetsParams {
  final String userId;
  final String name;
  final String type;
  final double percentage;
  final DateTime createdAt;

  CreateUserAssetsParams({
    required this.userId,
    required this.name,
    required this.type,
    required this.percentage,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'name': name,
      'type': type,
      'percentage': percentage,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
