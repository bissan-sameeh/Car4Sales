import 'package:carmarketapp/core/helpers/api_helpers/api_response.dart';
import 'package:carmarketapp/models/api/cars/car_api_model.dart';
import 'package:flutter/material.dart';

import '../../../core/errors/excpations.dart';
import '../../../core/errors/failure.dart';
import '../../../reprositories/customer/customer_cars_repository/customer_cars_repository.dart';

class CustomerCarsProvider extends ChangeNotifier {
  late CustomerCarsRepository _carsRepository;
  String? _selectedCountry="Locale";
  String? _selectedTransmission="Manual";
  String? _selectedPriceSort="Lowest to highest";
  String? get selectedCountry=>_selectedCountry;
  String?get selectedTransmission=>_selectedTransmission;
  String? get selectedPriceSort=>_selectedPriceSort;
  bool _filtersApplied = false;


  ApiResponse<List<CarApiModel>> _allSellerCars =
  ApiResponse.loading("loading cars");

  List<CarApiModel> _filteredCars = [];
  bool _isSearching = false;


  /// getter للـ ApiResponse (loading / error / completed)
  ApiResponse<List<CarApiModel>> get allSellerCars => _allSellerCars;

  List<CarApiModel> get cars {
    if (_allSellerCars.data == null) return [];

    if (_isSearching) {
      return _filteredCars;
    }

    if (_filtersApplied) {
      return _applyFilters(_allSellerCars.data!);
    }

    return _allSellerCars.data!;
  }
  changeCountry(String country){
    _selectedCountry=country;
    notifyListeners();
  } changeTransmission(String transmission){
    _selectedTransmission=transmission;
    notifyListeners();
  } changePrice(String price){
    _selectedPriceSort=price;
    notifyListeners();
  }




  CustomerCarsProvider() {
    _carsRepository = CustomerCarsRepository();
  }

  /// Fetch all cars (مرة وحدة)
  Future<void> fetchSellerCars() async {
    _allSellerCars = ApiResponse.loading("Loading All My Offer Cars!");
    notifyListeners();

    try {
      final response = await _carsRepository.fetchSellerCar();
      _allSellerCars = ApiResponse.completed(response);
      _filteredCars = []; // reset أي بحث سابق
      notifyListeners();
    } catch (error) {
      if (error is Failure) {
        _allSellerCars = ApiResponse.error(mapFailureToMessage(error));
      } else {
        _allSellerCars = ApiResponse.error("Unexpected error");
      }
      notifyListeners();
    }
  }



  /// Local search (بدون API)
  void searchCars(String query) {
    if (_allSellerCars.data == null) return;

    final q = query.trim().toLowerCase();

    _isSearching = q.isNotEmpty;

    if (!_isSearching) {
      _filteredCars = [];
      notifyListeners();
      return;
    }

    _filteredCars = _allSellerCars.data!.where((car) {
      final brand = car.brand?.toLowerCase() ?? '';
      final transmission = car.transmission?.toLowerCase() ?? '';
      final fuelType = car.fuelType?.toLowerCase() ?? '';
      final seats = car.seats?.toString() ?? '';
      final stock = car.quantityInStock?.toString() ?? '';

      return brand.contains(q) ||
          transmission.contains(q) ||
          fuelType.contains(q) ||
          seats.contains(q) ||
          stock.contains(q);
    }).toList();

    notifyListeners();
  }

  void applyFilters({
    String? country,
    String? transmission,
    String? priceSort,
  }) {
    _selectedCountry = country;
    _selectedTransmission = transmission;
    _selectedPriceSort = priceSort;
    _filtersApplied = true;
    notifyListeners();
  }

  void resetFilters() {
    _selectedCountry = null;
    _selectedTransmission = null;
    _selectedPriceSort = null;
    _filtersApplied = false;
    notifyListeners();
  }

  List<CarApiModel> _applyFilters(List<CarApiModel> cars) {
    List<CarApiModel> filteredCars = List.from(cars);
    // تصفية حسب البلد
    if (_selectedCountry != null && _selectedCountry != 'locate') {
      filteredCars = filteredCars.where((car) {
        // افترض أن موديل السيارة فيه حقل country
        return car.country?.toLowerCase() == _selectedCountry?.toLowerCase();
      }).toList();
    }

    // تصفية حسب نوع الناقل
    if (_selectedTransmission != null && _selectedTransmission != 'Transmission') {
      filteredCars = filteredCars.where((car) {
        return car.transmission?.toLowerCase() == _selectedTransmission?.toLowerCase();
      }).toList();
    }
// ترتيب حسب السعر
    if (_selectedPriceSort != null) {
      filteredCars.sort((a, b) {
        final priceA = a.price ?? 0;
        final priceB = b.price ?? 0;

        if (_selectedPriceSort == 'Lowest to highest' || _selectedPriceSort == 'low') {
          return priceA.compareTo(priceB);
        } else {
          return priceB.compareTo(priceA);
        }
      });
    }

    return filteredCars;
  }
  }




