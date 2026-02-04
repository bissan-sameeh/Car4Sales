import 'dart:convert';
import 'dart:io';

import 'package:carmarketapp/Cache/auth_storage.dart';
import 'package:carmarketapp/Cache/cache_controller.dart';
import 'package:carmarketapp/core/errors/excpations.dart';
import 'package:carmarketapp/core/errors/failure.dart';
import 'package:carmarketapp/core/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../network/network_info.dart';


class ApiBaseHelper {
  var responseJson;
  final NetworkInfoImpl networkInfo=NetworkInfoImpl(InternetConnectionChecker());
  AuthStorage authStorage=AuthStorage();

  Future<dynamic> get(String url) async {

    if (!(await networkInfo.isConnected)) {
      print('ssssssssssssssssssssssssssss');
      throw OfflineFailure();
    }
    try {

      final response = await http.get(Uri.parse(url), headers: await headers);
      print('Response Status: ${response.statusCode}');  // تحقق من حالة الاستجابة

      print(response.body);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw OfflineFailure();
    }
    on ServerException catch (e) {
      throw ServerFailure(e.message);

    }
    return responseJson;
  }

  // Future<dynamic> postDel(
  //   String url,
  // ) async {
  //   var responseJson;
  //
  //   try {
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers:await headers,
  //     );
  //     responseJson = _returnResponse(response);
  //   } on SocketException {
  //     throw OfflineFailure();
  //   }
  //   return responseJson;
  // }

  Future<dynamic> put(String url, {required  Map<String,dynamic> body}) async {
    if (!(await networkInfo.isConnected)) {
      throw OfflineFailure();
    }
    try {
      print("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
      print(jsonEncode(body));
      final response =
      await http.put(Uri.parse(url), body: jsonEncode(body), headers: await headers);

      print("update ${response.statusCode}");
      print("update "+response.body);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw OfflineFailure();
    }
    on ServerException catch (e){
      throw ServerFailure(e.message ?? 'Server Exception ');

    }
    return responseJson;
  }

  Future<dynamic> delete(String url) async {
    if (!(await networkInfo.isConnected)) {
      throw OfflineFailure();
    }
    print("deeeeeeeeeeeeeeeeelete");

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: await headers,
      );

      print(response);
      responseJson = _returnResponse(response);
      Future.value("delete successfully");
    } on ServerException catch (e){
      throw ServerFailure(e.message ?? 'Server Exception ');

    }

    on SocketException {
      throw OfflineFailure();
    }
    return true;
  }

  Future<Map<String, String>> get headers async {

    Map<String, String> header = <String, String>{};
    header[HttpHeaders.acceptHeader] = 'application/json';
    ///To do , put token here. after bearer
    header[HttpHeaders.contentTypeHeader] = 'application/json';

    if (authStorage.isLoggedIn==true) {
      String token=authStorage.getToken();
      header[HttpHeaders.authorizationHeader] =
          token;
      header[HttpHeaders.authorizationHeader]='Bearer $token';
      // print("token $token");
    }

    return header;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {

      case 200:

      case 201:
        return jsonDecode(response.body);
      case 204:
        return null;
      case 400:
      case 401:
      case 403:
      case 404:
        final message = _extractErrorMessage(response.body) ?? 'Client Error';
        throw ServerException(message);
      case 409:

      case 500:
        final message = _extractErrorMessage(response.body) ?? 'Server Error';
        throw ServerException(message);

      default:
        print("Unexpected server error ${response.statusCode}");
        throw ServerException('Unexpected server error ${response.statusCode}');
    }
  }


  Future<dynamic> post(String url, Map<String,dynamic> body) async {
    if (!(await networkInfo.isConnected)) {
      throw OfflineFailure();
    }
    try {
      print("post");
      final response = await http.post(
        Uri.parse(url),
        headers: await headers,
        body: jsonEncode(body),
      );
      print(response.body);
      print("jeafhe${response.statusCode}");
      print("kkkkkkkkkkkkkkkkkkkkkkkkkkk${response.body}");
      responseJson = _returnResponse(response);
    } on SocketException {
      throw OfflineFailure();
    }
    on ServerException catch (e) {
      throw ServerFailure(e.message);

    }
    return responseJson;
  }

  String? _extractErrorMessage(String body) {
    try {
      final decoded = jsonDecode(body);

      if (decoded is Map) {
        // 2️⃣ error: { message: "text" }
        if (decoded['error'] is Map && decoded['error']['message'] is String) {
          return decoded['error']['message'];
        }

        // 1️⃣ error: "text"
        if (decoded['error'] is String) {
          return decoded['error'];
        }



        // 3️⃣ message: "text"
        if (decoded['message'] is String) {
          return decoded['message'];
        }

        // 4️⃣ errors: [ { message: "text" } ]
        if (decoded['errors'] is List && decoded['errors'].isNotEmpty) {
          final firstError = decoded['errors'][0];
          if (firstError is Map && firstError['message'] is String) {
            return firstError['message'];
          }
        }
      }
    } catch (_) {}

    return null;
  }

}
