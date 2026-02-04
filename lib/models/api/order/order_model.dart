import '../cars/car_api_model.dart';

class Order {
  final int id;
  final int carId;
  final DateTime createdAt;
  final int buyerId;
  final double totalPrice;
  final int quantity;
  final CarApiModel car;

  Order({
    required this.id,
    required this.carId,
    required this.createdAt,
    required this.buyerId,
    required this.totalPrice,
    required this.quantity,
    required this.car,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      carId: json['carId'],
      createdAt: DateTime.parse(json['createdAt']),
      buyerId: json['buyerId'],
      totalPrice: double.parse(json['totalPrice'].toString()),
      quantity: json['quantity'],
      car: CarApiModel.fromJson(json['car']),
    );
  }
}
