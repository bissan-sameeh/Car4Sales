import 'package:carmarketapp/core/utils/constants.dart';
import 'package:carmarketapp/models/api/cars/car_api_model.dart';
import 'package:carmarketapp/models/api/cars/car_base_response.dart';
import 'package:carmarketapp/models/api/user/user_model.dart';

import '../../../core/helpers/api_helpers/api_base_helper.dart';

class ProfileRepository {
  late ApiBaseHelper _apiBaseHelper ;
  ProfileRepository(){
    _apiBaseHelper=ApiBaseHelper();
  }
  Future<UserModel> updateProfile({String? name,String? whatsapp}) async {
    Map<String,dynamic> body={
      "username":name,
      "whatsapp":whatsapp
    };
    final response=await _apiBaseHelper.put(updateProfileUrl, body: body );


    print(response);

    return UserModel.fromJson(response);
  }

}
