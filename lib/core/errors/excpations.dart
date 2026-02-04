import '../strings/failure.dart';
import 'failure.dart';

class ServerException implements Exception {
  final String message;
  ServerException(this.message);

  @override
  String toString() => message;
}

class EmptyCacheException implements Exception {}

class SocketException implements Exception {}
class UnauthorisedException implements Exception {}
String mapFailureToMessage(Failure failure) {
  if (failure is OfflineFailure) {
    print('network');
    return OFFLINE_FAILURE_MESSAGE;
  } else if (failure is ServerFailure) {
    return failure.message;
  } else {
    print('jjjjjjjjjjjjjjjjjjjjjj');

    return 'Unexpected Error! Please try again';
  }
}