import 'dart:convert';
import 'package:carmarketapp/core/helpers/api_helpers/api_base_helper.dart';
import 'package:carmarketapp/models/api/cars/car_api_model.dart';
import 'package:carmarketapp/models/api/cars/sold_car_model.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../../core/errors/failure.dart';
import '../../../core/network/network_info.dart';
import '../../../core/utils/constants.dart';
import '../../../models/api/cars/car_base_response.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import '../../models/api/auth/auth_response_model.dart';
import '../../models/api/user/user_model.dart';

class AuthRepository {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();
  final NetworkInfoImpl networkInfo = NetworkInfoImpl(
      InternetConnectionChecker());
  Future<AuthResponseModel?> login({required String email, required String password}) async {
    Map<String,dynamic> body={
      'email':email,
      'password':password
    };
    print(body);
   final response=await _apiBaseHelper.post(loginUrl,body );
   return AuthResponseModel.fromJson(response);
  }
  Future<UserModel?> register(
      {required String email,
      required String password,
      required bool isSeller,
      required String username,
      required String whatsapp}) async {
    Map<String,dynamic> body={
      'email':email,
      'password':password,
      'isSeller':isSeller,
      'username':username,
      'whatsapp':whatsapp
    };
   final response=await _apiBaseHelper.post(registerUrl,body );
   
   return UserModel.fromJson(response);
  }


  Future<dynamic> verifyOtp({required String otp,required String email}) async {
    Map<String,dynamic> body={"otp" :otp,"email":email};
    final response=await _apiBaseHelper.post(verifyOtpUrl,body );
    return response['message'];
  }
  Future<dynamic> forgetPassword({required String email}) async {
    Map<String,dynamic> body={"email":email};
    final response=await _apiBaseHelper.post(forgetPasswordUrl,body );
    print(response['message']);
    return response['message'];
  }
  Future<dynamic> resetPassword({required String email,required String newPassword}) async {
    Map<String,dynamic> body={"email":email,"newPassword": newPassword};
    final response=await _apiBaseHelper.post(resetPasswordUrl,body );
    return response['message'];
  }


}
