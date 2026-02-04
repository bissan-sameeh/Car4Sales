import 'order_model.dart';

class OrderResponse {
  final int length;
  final List<Order> orders;

  OrderResponse({
    required this.length,
    required this.orders,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      length: json['length'] as int,
      orders: (json['orders'] as List)
          .map((e) => Order.fromJson(e))
          .toList(),
    );
  }
}
