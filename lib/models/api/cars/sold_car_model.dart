import 'package:carmarketapp/models/api/cars/car_api_model.dart';

class SoldCarModel {
  String? brand;
  int? totalSold;
  int? totalBuyers;
  List<CarApiModel>? cars;
  SoldCarModel({
    this.brand,
    this.totalSold,
    this.totalBuyers,
    this.cars,  });

  factory SoldCarModel.fromJson(Map<String, dynamic> json) => SoldCarModel(
    brand: json["brand"],
    totalSold: json["totalSold"],
    totalBuyers: json["totalBuyers"],
    cars: json["cars"] == null ? [] : List<CarApiModel>.from(json["cars"]!.map((x) => CarApiModel.fromJson(x))),
  );

}