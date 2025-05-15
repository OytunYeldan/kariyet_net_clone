class UserModel {
  final int? id;
  final String email;
  final String password;
  final String userType;
  final String name;
  final String skills;
  final String phone;

  UserModel({
    this.id,
    required this.email,
    required this.password,
    required this.userType,
    required this.name,
    required this.skills,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'userType': userType,
      'name': name,
      'skills': skills,
      'phone': phone,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      userType: map['userType'],
      name: map['name'],
      skills: map['skills'],
      phone: map['phone'],
    );
  }
}
