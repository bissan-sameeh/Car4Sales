import 'dart:io';
import 'dart:typed_data';

import 'package:carmarketapp/core/errors/excpations.dart';
import 'package:carmarketapp/core/helpers/api_helpers/api_response.dart';
import 'package:carmarketapp/models/api/cars/car_api_model.dart';
import 'package:carmarketapp/models/api/cars/sold_car_model.dart';
import 'package:carmarketapp/reprositories/Dellear/cars_reprository/cars_reprositery.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/errors/failure.dart';
import '../../../core/strings/failure.dart';

class CarsProvider extends ChangeNotifier {
  late CarsRepository _carsRepository;

  late ApiResponse<CarApiModel> _addNewCar=ApiResponse.loading('Loading');
  late ApiResponse<CarApiModel> _updateCar = ApiResponse.loading('Loading');
  late ApiResponse<CarApiModel> _singleCar = ApiResponse.loading('Loading');
  late ApiResponse<bool> _deleteCar = ApiResponse.loading('Loading');
  late ApiResponse<List<CarApiModel>> _allCars=ApiResponse.loading('Loading');
  late ApiResponse<List<SoldCarModel>>
      _allSoldCars; // late ApiResponse<List<CarApiModel>> _allCars;
  ApiResponse<CarApiModel> get singleCar=>_singleCar;
  bool isLoading = false;

  CarsProvider() {
    _carsRepository = CarsRepository();
    // fetchAllCars();
    // fetchAllSoldCars();
    // fetchSingleCar(id);
    notifyListeners();
  }

  // ApiResponse<CarApiModel?> get singleCar => _singleCar ?? ApiResponse.completed(null);

  ApiResponse<CarApiModel> get addedCar => _addNewCar;

  ApiResponse<CarApiModel> get updatedCar => _updateCar;

  ApiResponse<bool> get deleteCar => _deleteCar;

  ApiResponse<List<CarApiModel?>> get allCars => _allCars;

  ApiResponse<List<SoldCarModel>> get allSoldCars => _allSoldCars;

  String _mapFailureToMessage(Failure failure) {
    if (failure is OfflineFailure) {
      print('network');

      return OFFLINE_FAILURE_MESSAGE;
    } else if (failure is ServerFailure) {
      return SERVER_FAILURE_MESSAGE;
    } else {
      print('jjjjjjjjjjjjjjjjjjjjjj');

      return 'Unexpected Error! Please try again';
    }
  }

  //to add car
  Future<void> addCar(
      {required String color,
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
    isLoading = true;
    notifyListeners();
    try {
      final response = await _carsRepository.sendCarDataWithImage(
          color: color,
          price: price,
          images: images,
          transmission: transmission,
          year: year,
          battery: battery,
          brand: brand.toString(),
          carType: carType.toString(),
          speed: speed,
          fuelType: fuelType.toString(),
          climate: climate,
          country: country.toString(),
          range: range,
          seats: seats,
          quantityInStock: quantityInStock, coverImage: coverImage);
      _addNewCar = ApiResponse.completed(response);
    ////  print(_addNewCar);
      notifyListeners();


      isLoading=false;

        print("is Loading $isLoading");



      notifyListeners();
    } catch (error) {
        isLoading=false;
         print(error);
         print(isLoading);

         if (error is Failure) {
           // print('[ssssssssssssssssssuuuuuuuu]');
          String message = _mapFailureToMessage(error);
          print(message);

          _addNewCar = ApiResponse.error(message);
          notifyListeners();

         } else {
          _addNewCar = ApiResponse.error("An unexpected error occurred.");
          notifyListeners();

         }

        notifyListeners();


    // notifyListeners();
    }


  }

  // to get all offer cars
  Future<void> fetchAllOffers() async {
    //   final response = await _carsRepository.getAllCars();
    print("fetchAllCars called");
    _allCars = ApiResponse.loading("Loading All My Offer Cars!");
    notifyListeners();
    try {
      final response = await _carsRepository.fetchAllOfferCars();

      print('ssssssssssssssssssssss${response?.length ??5}');

       _allCars = ApiResponse.completed(response);
        notifyListeners();

    } catch (error) {
      if (error is Failure) {
        String message = _mapFailureToMessage(error);

        _allCars = ApiResponse.error(message);
        notifyListeners();
      } // Log the error message

      notifyListeners();
    }
    return null;
  }

  //Sold Cars

  Future<List<SoldCarModel>?> fetchAllSoldCars() async {
    // final response = await _carsRepository.getAllCars();
    print("fetchAllSoldCars called");
    _allSoldCars = ApiResponse.loading("Loading All My Offer Cars!");

    notifyListeners();
    try {
      final response = await _carsRepository.getAllSoldCars();
      if (response != null) {
        print('Cars fetched successfully: ${response.length} cars found');
        _allSoldCars = ApiResponse.completed(response);
      } else {
        print('No cars found');
        _allSoldCars = ApiResponse.completed([]);
      }
    } catch (error) {
      if (error is Failure) {
        String message = _mapFailureToMessage(error);

        _allSoldCars = ApiResponse.error(message);
        notifyListeners();
      } // Log the error message

      notifyListeners();
    }
    return [];
  }

  //update car
  Future<CarApiModel?> updateCar(  {required String color,required int carId,
    required double price,
    required Uint8List carCoverImage,
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

    try {
      isLoading=true;
      notifyListeners();
      final response = await _carsRepository.updateCar(  color: color,
          price: price,
          images: images,
          transmission: transmission,
          year: year,
          battery: battery,
          brand: brand.toString(),
          carType: carType.toString(),
          speed: speed,
          fuelType: fuelType.toString(),
          climate: climate,
          country: country.toString(),
          range: range,
          seats: seats,
          quantityInStock: quantityInStock, carId: carId, coverImage: carCoverImage, );

      _updateCar = ApiResponse.completed(response);
      isLoading=false;
      notifyListeners();

      await fetchAllOffers();
      notifyListeners();
    } catch (error) {
      if (error is Failure) {
        String message = _mapFailureToMessage(error);
        _updateCar = ApiResponse.error(message);
        isLoading = false;
        notifyListeners();
      } else {
        _updateCar = ApiResponse.error('An unexpected error occurred.');
        isLoading = false;
        notifyListeners();
      }
    }

    isLoading=false;
    notifyListeners();

    return null;
  }

  //show Car details
  Future<CarApiModel?> fetchSingleCar(String carId) async {
   // ApiStatus
    print("fetch single car");

        _singleCar = ApiResponse.loading("Loading single car!");
    notifyListeners();
    try {
      final response = await _carsRepository.showCarDetails(id: carId);
      CarApiModel car = response;
      _singleCar = ApiResponse.completed(response);

      notifyListeners();
      return response;
    } catch (e) {
      print(e);
      if(e is Failure){

      final errorMsg=mapFailureToMessage(e);
       _singleCar = ApiResponse.error(errorMsg);
      }else{
        _singleCar = ApiResponse.error(e.toString());

      }

      notifyListeners();
    }
    return null;
  }

  Future<bool?> deleteSingleCar({required String carId}) async {
    _deleteCar = ApiResponse.loading('loading');
    try {

      final response = await _carsRepository.deleteCar(id: carId);

        print('ssskkkkkkkkkkkkkkkkkkkkk');
        _deleteCar = ApiResponse.completed(response);
         await fetchAllOffers();


        notifyListeners();



    }catch (error) {
      if (error is Failure) {
        String message = _mapFailureToMessage(error);

        _deleteCar = ApiResponse.error(message);
        notifyListeners();
      }
      // Log the error message
      else {
        _deleteCar = ApiResponse.error("An unexpected error occurred.");
        notifyListeners();
      }

      notifyListeners();
    }
    return null;
  }
}
