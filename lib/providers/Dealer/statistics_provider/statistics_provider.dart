import 'package:carmarketapp/models/api/cars/car_base_response.dart';
import 'package:carmarketapp/models/api/statistics/statistics_model.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/errors/failure.dart';
import '../../../core/helpers/api_helpers/api_response.dart';
import '../../../core/strings/failure.dart';
import '../../../reprositories/Dellear/statistics_reprository/statistics_reprository.dart';

class StatisticsProvider extends ChangeNotifier {
  late StatisticsRepository _statisticsRepository;
  ApiResponse<StatisticsBaseModel> _apiResponse =
      ApiResponse.loading('Loading');
  ApiResponse<CarBaseResponse> _topBrand = ApiResponse.loading('Loading');

  ApiResponse<StatisticsBaseModel> get getAllStatistics => _apiResponse;

  ApiResponse<CarBaseResponse> get topBrand => _topBrand;

  StatisticsProvider() {
    _statisticsRepository = StatisticsRepository();
    getMonthsStatistics();
  }

  Future<void> getTopBrand({required int month}) async {
    _topBrand = ApiResponse.loading('Loading');
    print('tttttttttttttttttttttttttttt');
    notifyListeners();
    try {
      final response = await _statisticsRepository.getTopBrand(month);

      _topBrand = ApiResponse.completed(response);

      notifyListeners();
    } catch (e) {
      if (e is Failure) {
        String message = _mapFailureToMessage(e);
        _apiResponse = ApiResponse.error(message);
        notifyListeners();
      } else {
        _apiResponse = ApiResponse.error('Unexpected Error!');
        notifyListeners();
      }
    }
  }

  Future<void> getMonthsStatistics() async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      print('ssssssssssssssssssssssssssss');
      final statisticsResponse = await _statisticsRepository.getStatistics();
      _apiResponse = ApiResponse.completed(statisticsResponse);
      print(_apiResponse);
      notifyListeners();
    } catch (e) {
      if (e is Failure) {
        String message = _mapFailureToMessage(e);
        _apiResponse = ApiResponse.error(message);
        notifyListeners();
      }
    }
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is OfflineFailure) {
      print('ggggggggggggggggggg');
      return OFFLINE_FAILURE_MESSAGE;
    } else if (failure is ServerFailure) {
      return SERVER_FAILURE_MESSAGE;
    } else {
      print('jjjjjjjjjjjjjjjjjjjjjj');

      return 'Unexpected Error! Please try again';
    }
  }
}
