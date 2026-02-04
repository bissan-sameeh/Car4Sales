// To parse this JSON data, do
//
//     final carBaseResponse = carBaseResponseFromJson(jsonString);

import 'dart:convert';

import 'package:carmarketapp/models/api/cars/car_api_model.dart';
import 'package:carmarketapp/models/api/cars/sold_car_model.dart';

CarBaseResponse carBaseResponseFromJson(String str) => CarBaseResponse.fromJson(json.decode(str));


class CarBaseResponse {
  int? length;
  List<CarApiModel>? cars;
  List<SoldCarModel>? soldCar;

  CarBaseResponse({
    this.length,
    this.soldCar,
     this.cars,
  });

  factory CarBaseResponse.fromJson(Map<String, dynamic> json) {

      try {
  return CarBaseResponse(
    length: json["length"],
    soldCar: (json["soldCars"] as List<dynamic>? ?? []) // ✅ تجنب null
        .map((x) => SoldCarModel.fromJson(x))
        .toList(),
    cars: (json['cars'] as List<dynamic>?)
      ?.map((e) {
  print('Parsing Car: $e');  // التحقق من كل عنصر يتم تحويله
  return CarApiModel.fromJson(e as Map<String, dynamic>);
  })
      .toList(),
  );
  } catch (e) {
  print('Error parsing CarBaseResponse: $e');
  return CarBaseResponse(cars: []);
}
}
    // cars: json["cars"] != null
    //     ? List<CarApiModel>.from(
    //     json["cars"].map((x) => CarApiModel.fromJson(x)))
    //     : [],


}
