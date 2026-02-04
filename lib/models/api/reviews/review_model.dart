import 'dart:convert';

import '../buyers/buyer_model.dart';
import '../cars/car_base_response.dart';

ReviewModel reviewBaseResponseFromJson(String str) => ReviewModel.fromJson(json.decode(str));

// String reviewBaseResponseToJson(ReviewModel data) => json.encode(data.toJson());

class ReviewModel {
  int? id;
  String? desc;
  int? carId;
  int? buyerId;
  String? createdAt;
  int? star;
  BuyerModel? buyer;
  CarBaseResponse? car;

  ReviewModel({
    this.id,
    this.desc,
    this.carId,
    this.buyerId,
    this.createdAt,
    this.star,
    this.buyer,
    this.car,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
    id: json["id"],
    desc: json["desc"],
    carId: json["carId"],
    buyerId: json["buyerId"],
    createdAt: json["createdAt"],
    star: json["star"],
    buyer: json["buyer"] == null ? null : BuyerModel.fromJson(json["buyer"]),
    car: json["car"] == null ? null : CarBaseResponse.fromJson(json["car"]),
  );

  // Map<String, dynamic> toJson() => {
  //   "id": id,
  //   "desc": desc,
  //   "carId": carId,
  //   "buyerId": buyerId,
  //   "createdAt": createdAt,
  //   "star": star,
  //   "buyer": buyer?.toJson(),
  //   "car": car?.toJson(),
  // };
}
