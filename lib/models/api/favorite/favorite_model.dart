
import 'package:carmarketapp/models/api/cars/car_api_model.dart';

class Favorites {
  int? id;
  int? carId;
  int? buyerId;
  String? createdAt;
  String? updatedAt;
  CarApiModel? car;

  Favorites({this.id, this.carId, this.buyerId, this.createdAt, this.updatedAt, this.car});

  Favorites.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    carId = json["carId"];
    buyerId = json["buyerId"];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
    car = json["car"] == null ? null : CarApiModel.fromJson(json["car"]);
  }


}
