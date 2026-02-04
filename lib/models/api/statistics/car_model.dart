
class Car {
  int id;
  String brand;
  int year;
  int remainingQuantity;
  int soldQuantity;

  Car({
    required this.id,
    required this.brand,
    required this.year,
    required this.remainingQuantity,
    required this.soldQuantity,
  });

  factory Car.fromJson(Map<String, dynamic> json) => Car(
    id: json["id"],
    brand: json["brand"],
    year: json["year"],
    remainingQuantity: json["remainingQuantity"],
    soldQuantity: json["soldQuantity"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "brand": brand,
    "year": year,
    "remainingQuantity": remainingQuantity,
    "soldQuantity": soldQuantity,
  };
}
