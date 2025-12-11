class UserEntity {
  final String id;
  final String email;
  final String password;
  final String? userName;
  UserEntity({
    required this.id,
    this.userName,
    required this.email,
    required this.password,
  });
  toMap() =>
      {'id': id, 'email': email, 'password': password, 'userName': userName};
}
