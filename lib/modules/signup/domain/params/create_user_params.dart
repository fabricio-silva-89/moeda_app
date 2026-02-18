class CreateUserParams {
  final String uid;
  final String email;
  final String name;
  final String? photoUrl;
  final DateTime createdAt;

  CreateUserParams({
    required this.uid,
    required this.email,
    required this.name,
    this.photoUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
