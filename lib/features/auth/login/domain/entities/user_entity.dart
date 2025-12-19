class UserEntity {
  final String id;
  final String email;

  final String? desplayName;
  UserEntity({
    required this.id,
    this.desplayName,
    required this.email,
  });
  toMap() => {'id': id, 'email': email, 'userName': desplayName};
}
