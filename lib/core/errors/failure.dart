import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {

  final String message;
  const Failure(this.message);
}

class OfflineFailure extends Failure {
  const OfflineFailure() : super("Network Error. Please try again.");

  @override
  // TODO: implement props
  List<Object?> get props => ["Network Error. Please try again."];
}
class ServerFailure extends Failure{
  const ServerFailure(super.message);

  @override
  List<Object?> get props => [message];
  @override
  String toString() => message;
}
// class EmptyCacheFailure extends Failure{
//   @override
//   // TODO: implement props
//   List<Object?> get props => [];
//
// }

class WrongDataFailure extends Failure{
  WrongDataFailure() : super("Wrong Data Error. Try again later.");

  @override
  // TODO: implement props
  List<Object?> get props => [];

}class UnauthorisedFailure extends Failure{
  const UnauthorisedFailure() : super("Unauthorised Failure Error. Please sign in!");

  @override
  // TODO: implement props
  List<Object?> get props => [];

}