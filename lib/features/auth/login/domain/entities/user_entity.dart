class UserEntity {
  final String id;
  final String email;
  final String? desplayName;
  final String role;

  UserEntity({
    required this.id,
    this.desplayName,
    required this.email,
    required this.role,
  });

  toMap() => {
    'id': id,
    'email': email,
    'userName': desplayName,
    'role': role,
  };
}
