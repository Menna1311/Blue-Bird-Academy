class UserEntity {
  final String email;
  final String password;
  final String? userName;
  UserEntity({
    this.userName,
    required this.email,
    required this.password,
  });
  toMap() => {'email': email, 'password': password, 'userName': userName};
}
