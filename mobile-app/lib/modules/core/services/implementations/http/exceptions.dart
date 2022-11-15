abstract class AppExceptionBase implements Exception {
  final String? message;
  // final String type;

  // AppException(this._message, this._type);

  // AppExceptionBase({@required this.message, @required this.type});
  AppExceptionBase({this.message}) {
    print("$runtimeType # msg:$message");
  }

  @override
  String toString() {
    return "$runtimeType :$message";
  }
}

class ApiException extends AppExceptionBase {
  ApiException(String? message) : super(message: message);
}

class FetchDataException extends AppExceptionBase {
  FetchDataException(String message) : super(message: message);
}

class BadRequestException extends AppExceptionBase {
  BadRequestException(String message) : super(message: message);
}

class UnauthorisedException extends AppExceptionBase {
  UnauthorisedException(String message) : super(message: message);
}

class InvalidInputException extends AppExceptionBase {
  InvalidInputException(String message) : super(message: message);
}

class ErrorTimeoutConnection extends AppExceptionBase {}

class ErrorNoInternetConnection extends AppExceptionBase {}

class UnHandledHttpException extends AppExceptionBase {
  final Object error;
  final StackTrace stackTrace;

  UnHandledHttpException(
    this.error,
    this.stackTrace,
  ) : super(message: error.toString());
}
