class PaymentResult {
  final bool isSuccess;
  final bool isCanceled;
  final String? message;

  PaymentResult.success()
      : isSuccess = true,
        isCanceled = false,
        message = null;

  PaymentResult.canceled()
      : isSuccess = false,
        isCanceled = true,
        message = 'Payment cancelled';

  PaymentResult.failed({this.message})
      : isSuccess = false,
        isCanceled = false;
}
