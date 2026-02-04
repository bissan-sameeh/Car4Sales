import 'package:carmarketapp/core/helpers/api_helpers/api_response.dart';
import 'package:carmarketapp/models/api/order/order_model.dart';
import 'package:flutter/material.dart';
import '../../../core/errors/excpations.dart';
import '../../../core/errors/failure.dart';
import '../../../reprositories/customer/orders_repository/orders_repository.dart';

class OrdersProvider extends ChangeNotifier {
  late OrdersRepository _ordersRepository;
  ApiResponse<List<Order>> _fetchAllOrders = ApiResponse.loading("loading cars");
  ApiResponse<List<Order>> get fetchAllOrdersResponse => _fetchAllOrders;


  OrdersProvider() {
    _ordersRepository =OrdersRepository();
  }


  ApiResponse<void> confirmOrderResponse =
  ApiResponse.loading("loading");

  Future<void> confirmOrder({
    required int carId,
    required int cartItemId,
  }) async
  {
    confirmOrderResponse = ApiResponse.loading("confirming...");
    print(confirmOrderResponse);
    notifyListeners();

    try {
      await _ordersRepository.confirmOrder(
        carId: carId,
        cartItemId: cartItemId,
      );
      confirmOrderResponse = ApiResponse.completed(null);
    } catch (e) {
      confirmOrderResponse =
          ApiResponse.error(e.toString());
    }

    notifyListeners();
  }
  Future<void> fetchAllOrders() async {
    print("feeetch alll orders");
    _fetchAllOrders = ApiResponse.loading("all orders items");
    // print(_fetchAllOrders);
    notifyListeners();
    try {
      final response = await _ordersRepository.getAllOrders();

      _fetchAllOrders = ApiResponse.completed(response);

      notifyListeners();
    } catch (error) {
      if (error is Failure) {
        String message = mapFailureToMessage(error);

        _fetchAllOrders = ApiResponse.error(message);
        notifyListeners();
      }

      notifyListeners();
    }
  }

}
