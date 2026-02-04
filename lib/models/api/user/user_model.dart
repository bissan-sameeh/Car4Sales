class UserModel {
  final int? id;
  final String? email;
  final String? password;
  final bool? isSeller;
  final String? createdAt;
   String? username;
  final String? whatsapp;
  final String? resetPasswordToken;
  final String? resetPasswordExpiry;

  UserModel({
     this.id,
     this.email,
     this.password,
     this.isSeller,
     this.createdAt,
     this.username,
     this.whatsapp,
    this.resetPasswordToken,
    this.resetPasswordExpiry,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      isSeller: json['isSeller'],
      createdAt: json['createdAt'],
      username: json['username'],
      whatsapp: json['whatsapp'],
      resetPasswordToken: json['resetPasswordToken'],
      resetPasswordExpiry: json['resetPasswordExpiry'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'isSeller': isSeller,
      'createdAt': createdAt,
      'username': username,
      'whatsapp': whatsapp,
      'resetPasswordToken': resetPasswordToken,
      'resetPasswordExpiry': resetPasswordExpiry,
    };
  }
}
