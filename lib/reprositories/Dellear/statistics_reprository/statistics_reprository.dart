import 'package:carmarketapp/core/helpers/api_helpers/api_base_helper.dart';
import 'package:carmarketapp/core/utils/constants.dart';

import '../../../models/api/cars/car_base_response.dart';
import '../../../models/api/revenue/revenue.dart';
import '../../../models/api/statistics/statistics_model.dart';

class StatisticsRepository{
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future<CarBaseResponse> getTopBrand(int monthParams,) async {
    ///url => soldCars
    final urlTop='$topStatisticsUrl?month=$monthParams&year=2025';
    final statisticsResponse=await _apiBaseHelper.get(urlTop);
    // print(CarBaseResponse.fromJson(statisticsResponse));
    // print(statisticsResponse);

    // List<Map<String, dynamic>> brands = statisticsResponse['cars'].map<Map<String, dynamic>>((car) {
    //   return {
    //     "brand": car['brand'],
    //     "totalSold": car['totalSold'],
    //   };
    // }).toList();


    return CarBaseResponse.fromJson(statisticsResponse);
  }

  Future<StatisticsBaseModel> getStatistics() async {

    ///url => soldCars
    final statisticsResponse=await _apiBaseHelper.get(statisticsUrl);

    return StatisticsBaseModel.fromJson(statisticsResponse);
  }



}

