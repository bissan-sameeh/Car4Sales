import 'package:carmarketapp/core/helpers/api_helpers/api_response.dart';
import 'package:carmarketapp/core/utils/converter_helper.dart';
import 'package:carmarketapp/models/api/revenue/revenue.dart';
import 'package:carmarketapp/models/api/seller/seller_model.dart';
import 'package:flutter/cupertino.dart';

import 'package:intl/intl.dart';

import '../../../core/errors/failure.dart';
import '../../../core/strings/failure.dart';
import '../../../reprositories/Dellear/dellear_repository/delear_repository.dart';
import '../../../reprositories/Dellear/revenue_reprository/revenue_reprository.dart';

class SellerProvider extends ChangeNotifier with ConverterHelper {
  late DellearRepository _dellearRepository;

  late ApiResponse<Seller> _seller;



  ApiResponse<Seller> get seller => _seller;

  SellerProvider() {
    _dellearRepository = DellearRepository();
//    fetchSellerData();
    notifyListeners();
  }

 Future<void> fetchSellerData() async {
    _seller = ApiResponse.loading('Loading Seller data!');
    notifyListeners();
    try {
      final response = await _dellearRepository.getSellerData();
      print(response);
      _seller = ApiResponse.completed(response);


      notifyListeners();
    } catch (e) {
      if (e is Failure) {
        String error = _mapFailureToMessage(e);
        _seller = ApiResponse.error(error);
        notifyListeners();
      } else {
        _seller = ApiResponse.error(e.toString());
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
