import 'package:tello_social_app/modules/core/error/failure.dart';

enum GroupFailureType {
  serverError,
  validationError,
  authorizationError,
}

class GroupFailure extends BaseFailure {
  final GroupFailureType type;
  // final String? msg;
  GroupFailure._(this.type, {required super.message});

  factory GroupFailure.serverError(String message) => GroupFailure._(GroupFailureType.serverError, message: message);
  factory GroupFailure.validationError(String message) =>
      GroupFailure._(GroupFailureType.validationError, message: message);
  factory GroupFailure.authorizationError(String message) =>
      GroupFailure._(GroupFailureType.authorizationError, message: message);
}
