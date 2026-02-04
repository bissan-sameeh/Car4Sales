import 'package:flutter_stripe/flutter_stripe.dart';

import '../../core/helpers/api_helpers/api_base_helper.dart';
import '../../core/utils/constants.dart';
import '../../models/api/payment_result_model.dart';

class PaymentRepository {
  Future<PaymentResult> pay({
    required int carId,
    required double totalPrice,
    required int quantity,
  }) async {
    try {
      final clientSecret = await _getClientSecret(
        carId: carId,
        totalPrice: totalPrice * 100,
        quantity: quantity,
      );

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Bissan',
          // style: ThemeMode.dark,
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      return PaymentResult.success();
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        return PaymentResult.canceled();
      }
      return PaymentResult.failed(
        message: e.error.localizedMessage,
      );
    }
  }

  Future<String> _getClientSecret({
    required int carId,
    required double totalPrice,
    required int quantity,
  }) async {
    final api = ApiBaseHelper();
    final response = await api.post(paymentUrl, {
      'carId': carId,
      'totalPrice': totalPrice,
      'quantity': quantity,
    });
    return response['clientSecret'];
  }
}
