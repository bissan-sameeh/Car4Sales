import 'package:carmarketapp/models/api/cars/car_api_model.dart';

class Cart {
  final int id;
  final int carId;
  final int quantity;
  final int totalPrice;
  final int buyerId;
  final String createdAt;
  final String updatedAt;
  final CarApiModel? car;

  Cart({
    required this.id,
    required this.carId,
    required this.quantity,
    required this.totalPrice,
    required this.buyerId,
    required this.createdAt,
    required this.updatedAt,
     this.car,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      carId: json['carId'],
      quantity: json['quantity'],
      totalPrice: json['totalPrice'],
      buyerId: json['buyerId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      car: json['car'] != null ? CarApiModel.fromJson(json['car']) : null,
    );
  }
}