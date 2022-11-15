import 'package:tello_social_app/modules/core/error/failure.dart';

enum AuthFailureType {
  serverError,
  invalidPhoneNumber,
  sessionExpired,
  smsCodeExpired,
  smsCodeInvalid,
  smsAutoRetrivalTimeout,
  unhandledException
}

class AuthFailure extends IFailure {
  final AuthFailureType type;
  final String? msg;
  AuthFailure._(this.type, {this.msg});

  @override
  @override
  String toString() {
    return "$runtimeType.${type.name} ${msg ?? ''}";
  }

  factory AuthFailure.serverError({required String msg}) => AuthFailure._(AuthFailureType.serverError, msg: msg);
  factory AuthFailure.invalidPhoneNumber({String? msg}) => AuthFailure._(AuthFailureType.invalidPhoneNumber, msg: msg);
  factory AuthFailure.sessionExpired() => AuthFailure._(AuthFailureType.sessionExpired);
  factory AuthFailure.smsCodeExpired() => AuthFailure._(AuthFailureType.smsCodeExpired);
  factory AuthFailure.smsCodeInvalid() => AuthFailure._(AuthFailureType.smsCodeInvalid);
  factory AuthFailure.smsAutoRetrivalTimeout() => AuthFailure._(AuthFailureType.smsAutoRetrivalTimeout);
  factory AuthFailure.unhandledException(String msg) => AuthFailure._(AuthFailureType.unhandledException, msg: msg);
}
