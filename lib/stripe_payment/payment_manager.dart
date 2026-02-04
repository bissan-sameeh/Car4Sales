import 'package:carmarketapp/core/errors/excpations.dart';
import 'package:carmarketapp/core/errors/failure.dart';
import 'package:carmarketapp/core/helpers/api_helpers/api_base_helper.dart';
import 'package:carmarketapp/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

import '../models/api/payment_result_model.dart';

abstract class PaymentManager {
  static Future<PaymentResult> makePayment({
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

      await _initializedPaymentSheet(clientSecret: clientSecret);
      await Stripe.instance.presentPaymentSheet();

      return PaymentResult.success();

    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        return PaymentResult.canceled();
      }
      return PaymentResult.failed(
        message:  _getStripeErrorMessage(e),
      );

    } on Failure catch (e) {
      return PaymentResult.failed(
        message: mapFailureToMessage(e),
      );

    } catch (_) {
      return PaymentResult.failed(
        message: 'Unexpected error occurred. Please try again',
      );
    }
  }


  static String _getStripeErrorMessage(StripeException e) {
      switch (e.error.code) {
        case FailureCode.Canceled:
          print("cancelled");
          return 'Payment was cancelled by user';
        case FailureCode.Failed:
          return 'Payment failed. Please check your payment details';
        case FailureCode.Timeout:
          return 'Payment timed out. Please try again';



        default:
          return 'Payment failed: ${e.error.localizedMessage}';
      }}

  static Future<void> _initializedPaymentSheet({
    required String clientSecret,
  }) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'Bissan',
        appearance: PaymentSheetAppearance(
          colors: PaymentSheetAppearanceColors(
            background: kBlackColor,
            componentBackground: kLightBlackColor,

            primary: kAmberColor, // Changed to amber for primary button
            componentBorder: Colors.grey.withOpacity(0.3),
            componentDivider: Colors.grey.withOpacity(0.2),
            primaryText: kWhite,
            secondaryText: Colors.white70,
            componentText: kWhite,
            placeholderText: Colors.white54,
            icon: kWhite,
            error: Colors.redAccent,
          ),

        ),
        // إعدادات إضافية لتحسين المظهر
        style: ThemeMode.dark,
        primaryButtonLabel: 'Pay Now',
        allowsDelayedPaymentMethods: false,
      ),
    );
  }

  static Future<String> _getClientSecret({
    required int carId,
    required double totalPrice,
    required int quantity,
  }) async {
    ApiBaseHelper apiBaseHelper = ApiBaseHelper();
    Map<String, dynamic> body = {
      'carId': carId,
      'totalPrice': totalPrice,
      'quantity': quantity,
    };
    final response = await apiBaseHelper.post(paymentUrl, body);
    final clientSecret = response['clientSecret'];
    return clientSecret;
  }


}