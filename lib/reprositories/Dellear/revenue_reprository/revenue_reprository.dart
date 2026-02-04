import 'package:carmarketapp/core/helpers/api_helpers/api_base_helper.dart';
import 'package:carmarketapp/core/utils/constants.dart';

import '../../../models/api/revenue/revenue.dart';

class RevenueRepository{
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future<RevenueModel> getMonthlyRevenue() async {
    print('rrrrrrrrrrrrrrrrrr');
    ///url => soldCars
    final revenuesResponse=await _apiBaseHelper.get(revenueUrl);
    // print('rrrrrrrrrrrrrrrrrrrrr');

    return RevenueModel.fromJson(revenuesResponse);
  }



}

