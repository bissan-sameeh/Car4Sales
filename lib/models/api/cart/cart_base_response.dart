import 'package:carmarketapp/models/api/cart/cart_model.dart';

class CartBaseResponse {
  final int length;
  final List<Cart> cartItems;

  CartBaseResponse({required this.length, required this.cartItems});

  factory CartBaseResponse.fromJson(Map<String, dynamic> json) {
    return CartBaseResponse(
      length: json['length'],
      cartItems: (json['cartItems'] as List)
          .map((e) => Cart.fromJson(e))
          .toList(),
    );
  }
}
