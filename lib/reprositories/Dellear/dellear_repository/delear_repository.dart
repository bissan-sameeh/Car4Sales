import 'package:carmarketapp/core/helpers/api_helpers/api_base_helper.dart';
import 'package:carmarketapp/core/utils/constants.dart';
import 'package:carmarketapp/models/api/seller/seller_model.dart';

import '../../../models/api/revenue/revenue.dart';
import '../../../models/api/seller/seller_base_response.dart';

class DellearRepository{
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();


    Future<Seller?> getSellerData() async {
    print('rrrrrrrrrrrrrrrrrr');
    ///url => soldCars
    final sellerResponse=await _apiBaseHelper.get(sellerUrl);
     print(sellerResponse);

    return SellerBaseResponse.fromJson(sellerResponse).seller;
    }



    }








