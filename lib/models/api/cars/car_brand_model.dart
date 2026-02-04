import 'package:carmarketapp/models/api/cars/car_api_model.dart';

class CarBrandModel{
  List<CarApiModel>? soldCars;
  int? totalSold;
  int? totalRemaining;

  CarBrandModel({
    this.soldCars,
    this.totalSold,
    this.totalRemaining,
  });

  factory CarBrandModel.fromJson(Map<String, dynamic> json) => CarBrandModel(
    soldCars: json["soldCars"] == null ? [] : List<CarApiModel>.from(json["soldCars"]!.map((x) => CarApiModel.fromJson(x))),
    totalSold: json["totalSold"],
    totalRemaining: json["totalRemaining"],
  );


}