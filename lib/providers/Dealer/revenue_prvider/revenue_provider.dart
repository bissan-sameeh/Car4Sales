import 'package:carmarketapp/core/helpers/api_helpers/api_response.dart';
import 'package:carmarketapp/core/utils/converter_helper.dart';
import 'package:carmarketapp/models/api/revenue/revenue.dart';
import 'package:flutter/cupertino.dart';

import 'package:intl/intl.dart';

import '../../../core/errors/failure.dart';
import '../../../core/strings/failure.dart';
import '../../../reprositories/Dellear/revenue_reprository/revenue_reprository.dart';

class RevenueProvider extends ChangeNotifier with ConverterHelper {
  late RevenueRepository _revenuesRepository;

  late ApiResponse<RevenueModel> _revenueMonthly= ApiResponse.loading('Loading Revenue');

  List<String> monthsList = [];
  double totalRevenue = 0.0;
  List<double> revenueValues = [];

  ApiResponse<RevenueModel> get revenueMonthly => _revenueMonthly;

  RevenueProvider() {
    _revenuesRepository = RevenueRepository();
    fetchMonthlyRevenue();
    notifyListeners();
  }

   Future<void> fetchMonthlyRevenue() async {
    _revenueMonthly = ApiResponse.loading('Loading Revenue');
    notifyListeners();
    try {
      final response = await _revenuesRepository.getMonthlyRevenue();
      _revenueMonthly = ApiResponse.completed(response);

      if (response.monthlyRevenue != null) {
        List<MapEntry<String, double>> sortedData = response
            .monthlyRevenue!.entries
            .map((entry) => MapEntry(entry.key, entry.value.toDouble()))
            .toList(); // entries that convert the map into Iterable<MapEntry<k,V> => {'2025-02':10000,'2025-1':800000} => Iterable<MapEntry<String,dynamic>>(
        // [MapEntry("2025-02", 100000), MapEntry("2025-01", 80000)]) . map () => convert each element to [MapEntry('2025-1',100000),MapEntry('2025-2' ] => returned type from iterable to list is (List<MapEntry<String,double>)

        print(sortedData);
        sortedData.sort((a, b) => a.key
            .compareTo(b.key)); //ترتيب تصاعدي لو عكست البراميتر بصير تنازلي
        monthsList = sortedData
            .map((e) => formatMonth(e.key))
            .toList(); //convert {'2025-9' => 'sep'}
        revenueValues = sortedData
            .map(
              (e) => e.value,
            )
            .toList(); //store values
        totalRevenue = response.totalRevenue!;
      }
      notifyListeners();
    } catch (e) {
      if (e is Failure) {
        String error = _mapFailureToMessage(e);
        _revenueMonthly = ApiResponse.error(error);
        notifyListeners();
      } else {
        _revenueMonthly = ApiResponse.error(e.toString());
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
