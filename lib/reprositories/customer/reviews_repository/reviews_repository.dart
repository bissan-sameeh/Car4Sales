import 'package:carmarketapp/core/utils/constants.dart';
import 'package:carmarketapp/models/api/cart/cart_base_response.dart';
import 'package:carmarketapp/models/api/cart/cart_model.dart';

import '../../../core/helpers/api_helpers/api_base_helper.dart';

class ReviewsRepository {
  late ApiBaseHelper _apiBaseHelper;

  ReviewsRepository() {
    _apiBaseHelper = ApiBaseHelper();
  }
  Future <void> addReview({required int carId,required int rate,required String comment}) async {
    print("addddddddddddddddddd");
    Map<String,dynamic> body={ "carId": carId,
    "star": rate,
    "desc": comment};
    final response=await _apiBaseHelper.post(addReviewUrl, body);
    print(response);
    // return Cart.fromJson(response);

  }


}