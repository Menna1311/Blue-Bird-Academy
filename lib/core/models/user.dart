class User {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? gender;
  int? age;
  int? weight;
  int? height;
  String? activityLevel;
  String? goal;
  String? photo;
  String? createdAt;
  String? token;
  String? password;
  String? rePassword;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.gender,
    this.age,
    this.weight,
    this.height,
    this.activityLevel,
    this.goal,
    this.photo,
    this.createdAt,
    this.token,
    this.password,
    this.rePassword,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      gender: json['gender'] as String?,
      age: json['age'] as int?,
      weight: json['weight'] as int?,
      height: json['height'] as int?,
      activityLevel: json['activityLevel'] as String?,
      goal: json['goal'] as String?,
      photo: json['photo'] as String?,
      createdAt: json['createdAt'] as String?,
      token: json['token'] as String?,
      password: json['password'] as String?,
      rePassword: json['rePassword'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'gender': gender,
      'age': age,
      'weight': weight,
      'height': height,
      'activityLevel': activityLevel,
      'goal': goal,
      'photo': photo,
      'createdAt': createdAt,
      'token': token,
      'password': password,
      'rePassword': rePassword,
    };
  }
}
