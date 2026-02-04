import 'package:carmarketapp/core/utils/constants.dart';
import 'package:carmarketapp/models/api/cart/cart_base_response.dart';
import 'package:carmarketapp/models/api/cart/cart_model.dart';

import '../../../core/helpers/api_helpers/api_base_helper.dart';

class CartRepository {
  late ApiBaseHelper _apiBaseHelper;

  CartRepository() {
    _apiBaseHelper = ApiBaseHelper();
  }
  Future <Cart> addCartItem({required int carId,required int quantity}) async {
    print("addddddddddddddddddd");
    Map<String,dynamic> body={"carId":carId,"quantity":quantity};
   final response=await _apiBaseHelper.post(cartUrl, body);
   return Cart.fromJson(response);

  }
  Future <void> deleteCart({required String carId}) async {
    print(deleteCartUrl+carId);
   await _apiBaseHelper.delete(deleteCartUrl+carId);

  } Future <Cart> updateCart({required int quantity,required String carId}) async {
    print("updateeeeeeeeeeeeeeeeee now!");
print(deleteCarUrl+carId);
  final response= await _apiBaseHelper.put(deleteCartUrl+carId,body: {'quantity' : quantity});
   print("updateeeeeeeeeeeeeeeeee $response");
   print(Cart.fromJson(response));

  return Cart.fromJson(response);
  } Future <List<Cart>?> getCartItems() async {
   final response=await _apiBaseHelper.get(cartUrl);
   return CartBaseResponse.fromJson(response).cartItems;
  }

  

}