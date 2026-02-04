import 'package:carmarketapp/core/utils/constants.dart';
import 'package:carmarketapp/models/api/cars/car_api_model.dart';
import 'package:carmarketapp/models/api/cars/car_base_response.dart';

import '../../../core/helpers/api_helpers/api_base_helper.dart';

class CustomerCarsRepository {
   late ApiBaseHelper _apiBaseHelper ;
  CustomerCarsRepository(){
    _apiBaseHelper=ApiBaseHelper();
  }
  Future<List<CarApiModel>?> fetchSellerCar() async {
    final response=await _apiBaseHelper.get(getCustomersCarsUrl );
    print(response);

    return CarBaseResponse.fromJson(response).cars;
  }

}
