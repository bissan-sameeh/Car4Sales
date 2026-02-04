class BuyerModel {
  int? id;
  String? name;
  String? email;
  String? username;

  BuyerModel({
    this.id,
    this.name,
    this.email,
    this.username,

  });

  factory BuyerModel.fromJson(Map<String, dynamic> json) => BuyerModel(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    username: json["username"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "username": username,

  };
}
