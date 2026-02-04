import 'package:flutter/material.dart';

import '../../../core/errors/excpations.dart';
import '../../../core/errors/failure.dart';
import '../../../core/helpers/api_helpers/api_response.dart';
import '../../../reprositories/customer/reviews_repository/reviews_repository.dart';

class ReviewsProvider extends ChangeNotifier {
  late ReviewsRepository _reviewsRepository;

  ApiResponse<void> _addReview = ApiResponse.initial("inital");
  ApiResponse<void> get addReviewResponse => _addReview;

  bool get isLoading => _addReview.status == ApiStatus.LOADING;

  ReviewsProvider() {
    _reviewsRepository = ReviewsRepository();
  }

  Future<void> addReview({
    required int carId,
    required int rate,
    required String comment,
  }) async {
    _addReview = ApiResponse.loading("Adding review...");
    notifyListeners();

    try {
      await _reviewsRepository.addReview(
        carId: carId,
        rate: rate,
        comment: comment,
      );

      _addReview = ApiResponse.completed(null);
    } catch (error) {
      if (error is Failure) {
        final message = mapFailureToMessage(error);
        _addReview = ApiResponse.error(message);
      } else {
        _addReview = ApiResponse.error(error.toString());
      }
    }

    notifyListeners();
  }
}
