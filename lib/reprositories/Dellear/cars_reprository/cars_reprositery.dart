import 'dart:convert';
import 'package:carmarketapp/Cache/auth_storage.dart';
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

class CarsRepository {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  String token = AuthStorage().getToken();
      // 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaXNTZWxsZXIiOnRydWUsImlhdCI6MTczNzg4NzEyM30.5uWo0kl5YpYiLKnrRym7w6cF5jgD_PDChLHQ1hJgsEg';
  final NetworkInfoImpl networkInfo = NetworkInfoImpl(
      InternetConnectionChecker());

  Future<CarApiModel?> sendCarDataWithImage({required String color,
    required double price,
    required Uint8List coverImage,
    required List<Uint8List> images,
    required String transmission,
    required int year,
    required int battery,
    required String brand,
    required String carType,
    required double speed,
    required String fuelType,
    required bool climate,
    required String country,
    required double range,
    required int seats,
    required int quantityInStock}) async {
    if (!(await networkInfo.isConnected)) {
      print('kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkiiiiiiiiiiiiiiiiiiiiiiiii');
      throw OfflineFailure();
    }
    var url = Uri.parse(addNewCarUrl);



    // بيانات السيارة
    Map<String, dynamic> carData = {
      'color': color,
      'price': price,
      'transmission': transmission,
      'year': year,
      'battery': battery,
      'brand': brand,
      'carType': carType,
      'speed': speed,
      'fuelType': fuelType,
      'climate': climate,
      'country': country,
      'range': range,
      'seats': seats,
      'quantityInStock': quantityInStock,
    };

    if (!(await networkInfo.isConnected)) {
      throw OfflineFailure();
    }

    var request = http.MultipartRequest('POST', url)
      ..fields
          .addAll(carData.map((key, value) => MapEntry(key, value.toString())))
      ..headers['Authorization'] = 'Bearer $token';
    print(AuthStorage().getRole());

    List<Uint8List> allImages = [coverImage, ...images];


   print([coverImage, ...images]);

    for (int i = 0; i <allImages.length; i++) {
      request.files.add(http.MultipartFile.fromBytes(
        'images', // Field name in API
        allImages[i],
        filename: 'image_$i.jpg',
      ));
    }

    // Send request

    try {
      var response = await request.send();
      String responseBody = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        print('Car created successfully');
        return CarApiModel.fromJson(jsonDecode(responseBody));
      } else {
        print('Failed to create car: ${response.statusCode}');
        // Log the response body for debugging
        String responseBody = await response.stream.bytesToString();

        print('Response body: $responseBody');
      }
      if (response.statusCode == 401) {
        String responseBody = await response.stream.bytesToString();

        print('Unauthorized: $responseBody');

        return null;
      }
    } catch (e) {
      print('Error sending request: $e');


      return null;
    }
    // images.removeAt(0);

    return null;
  }


  Future<List<CarApiModel>?> fetchAllOfferCars() async {
    print('ssssssssssssss');
    final allCars = await _apiBaseHelper.get(allOfferCars);
    print('jjjjjjjjjjjjjjjjjjjj');
    // print('API Response: $allCars');
     print(CarBaseResponse.fromJson(allCars).cars?.length ?? 5);

    return CarBaseResponse.fromJson(allCars).cars;
  }

  Future<bool> deleteCar({required String id}) async {
    print('oooooooooooooooooooooo');

    ///url => soldCars
    final response = await _apiBaseHelper.delete(deleteCarUrl + id);

    print('message');

    if (response is Map<String, dynamic> && response.containsKey('message')) {
      return response['message'].toString().contains('successfully');
    }

    return false;
  }

  Future<List<SoldCarModel>?> getAllSoldCars() async {
    print('yyyyyyyyyyyyyyyyyyyyyyyyyyy');

    ///url => soldCars
    final allSoldCars = await _apiBaseHelper.get(allSellerCars);
    return CarBaseResponse
        .fromJson(allSoldCars)
        .soldCar;
  }

  Future<CarApiModel> showCarDetails({required String id}) async {
    final showCarResult = await _apiBaseHelper.get(showCarDetailsUrl + id);
    return CarApiModel.fromJson(showCarResult);
  }

  //
//   Future<CarApiModel?> updateCar({required String color,
//     required double price,
//     required Uint8List coverImage, // الصورة التي سيتم تحديثها
//     required List<Uint8List?>? images, // صور إضافية إن وجدت
//     required String transmission,
//     required int year,
//     required int battery,
//     required String brand,
//     required String carType,
//     required double speed,
//     required String fuelType,
//     required bool climate,
//     required String country,
//     required double range,
//     required int seats,
//     required int quantityInStock,
//     required int carId}) async {
//     images?.insert(0, coverImage);
//
//     Map<String, dynamic> carData = {
//       'color': color,
//       'price': price,
//       'transmission': transmission,
//       'year': year,
//       'battery': battery,
//       'brand': brand,
//       'carType': carType,
//       'speed': speed,
//       'fuelType': fuelType,
//       'climate': climate,
//       'country': country,
//       'range': range,
//       'seats': seats,
//       'quantityInStock': quantityInStock,
//     };
//
//     var url = Uri.parse(updateCarUrl+ carId.toString());
//
//
//       final response = await _apiBaseHelper.put(
//         updateCarUrl + carId.toString(),
//         body: (carData), // إرسال البيانات بتنسيق JSON
//
//       );
//     var request = http.MultipartRequest('PUT',url)
//       ..fields
//           .addAll(carData.map((key, value) => MapEntry(key, value.toString())))
//       ..headers['Authorization'] = 'Bearer $token';
//
//     for (int i = 0; i < images!.length; i++) {
//       request.files.add(http.MultipartFile.fromBytes(
//         'images', // Field name in API
//         images[i]!,
//         filename: 'image_$i.jpg',
//       ));
//     }
//
//
// return CarApiModel.fromJson(response);
//
//   }


  Future<CarApiModel?> updateCar({
    required int carId,
    required String color,
    required double price,
    required Uint8List coverImage,
    required List<Uint8List?>? images,
    required String transmission,
    required int year,
    required int battery,
    required String brand,
    required String carType,
    required double speed,
    required String fuelType,
    required bool climate,
    required String country,
    required double range,
    required int seats,
    required int quantityInStock,
  }) async {
    if (!(await networkInfo.isConnected)) {
      throw OfflineFailure();
    }

    var url = Uri.parse('$updateCarUrl$carId');

    final request = http.MultipartRequest('PUT', url);

    // ✅ إضافة التوكن
    request.headers['Authorization'] = 'Bearer $token';

    // ✅ إعداد الحقول النصية
    Map<String, dynamic> fields = {
      'color': color,
      'price': price.toString(),
      'transmission': transmission,
      'year': year.toString(),
      'battery': battery.toString(),
      'brand': brand,
      'carType': carType,
      'speed': speed.toString(),
      'fuelType': fuelType,
      'climate': climate.toString(),
      'country': country,
      'range': range.toString(),
      'seats': seats.toString(),
      'quantityInStock': quantityInStock.toString(),
    };


    request.fields.addAll(fields.map((k, v) => MapEntry(k, v.toString())));


    List<Uint8List?>? allImages = [coverImage, ...?images];




    for (int i = 0; i <allImages.length; i++) {
      request.files.add(http.MultipartFile.fromBytes(
        'images', // Field name in API
        allImages[i]!,
        filename: 'image_$i.jpg',
      ));
    }

    try {
      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();

      print("📦 Status: ${streamedResponse.statusCode}");
      print("📦 Response: $responseBody");

      if (streamedResponse.statusCode == 200 || streamedResponse.statusCode == 201) {
        return CarApiModel.fromJson(jsonDecode(responseBody));
      } else {

        // رجّع null مع طباعة الخطأ
        return null;
      }
    } catch (e) {

      print("⚠️ Exception: $e");
      return null;
    }
  }


  // Future<void> updateCar() async {
  //   var url = Uri.parse('$updateCarUrl$carId');
  //
  //   Map<String, dynamic> carData = {
  //     'color': '#${(color as Color).value.toRadixString(16)}',
  //     'price': 10000,
  //     'transmission': 'Manual',
  //     'year': 1902,
  //     'battery': 54,
  //     'brand': 'Abadal',
  //     'carType': 'luxury',
  //     'speed': 150,
  //     'fuelType': 'Gasoline',
  //     'climate': true,
  //     'country': 'Albania',
  //     'range': 300,
  //     'seats': 5,
  //     'quantityInStock': 2,
  //   };
  //
  //   var response = await http.put(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     },
  //     body: jsonEncode(carData),
  //   );
  //
  //   print('Response ${response.statusCode}');
  //   print('Body ${response.body}');
  // }


}

