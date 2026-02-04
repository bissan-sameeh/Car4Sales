import '../../../core/helpers/api_helpers/api_base_helper.dart';
import '../../../core/utils/constants.dart';
import '../../../models/api/order/order_model.dart';
import '../../../models/api/order/order_response_model.dart';

class OrdersRepository {
  late ApiBaseHelper _apiBaseHelper ;
  OrdersRepository(){
    _apiBaseHelper=ApiBaseHelper();
  }




  Future<void> confirmOrder({
    required int carId,
    required int cartItemId,
  }) async {
    await _apiBaseHelper.post(confirmOrderUrl, {
      'carId': carId,
      'cartItemId': cartItemId,
    });
  }
  Future<List<Order>> getAllOrders() async {
    final response = await _apiBaseHelper.get(ordersUrl);

    try {
      final orders = OrderResponse.fromJson(response).orders;
      print("✅ Orders parsed: ${orders.length}");
      return orders;
    } catch (e, s) {
      print("❌ Parsing error");
      print(e);
      print(s);
      rethrow;
    }
  }

}