
class Seller {
  String? username;
  String? email;
  dynamic whatsapp;
  int? averageStars;

  Seller({
    this.username,
    this.whatsapp,
    this.email,
    this.averageStars,
  });

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
    username: json["username"],
    whatsapp: json["whatsapp"],
    email: json["email"],
    averageStars: json["averageStars"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "whatsapp": whatsapp,
    "email": email,
    "averageStars": averageStars,
  };
}
