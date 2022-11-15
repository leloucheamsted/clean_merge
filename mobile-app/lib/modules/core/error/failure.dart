abstract class IFailure {}

class BaseFailure implements IFailure {
  final String message;
  final StackTrace? stackTrace;
  BaseFailure({
    required this.message,
    this.stackTrace,
  });

  @override
  String toString() {
    return "$runtimeType :$message";
  }
}

// class ServerFailure implements IFailure {}
class ServerFailure extends BaseFailure {
  final String code;
  ServerFailure({
    required this.code,
    required super.message,
  });
}

class RuntimeFailure extends BaseFailure {
  RuntimeFailure({required super.message, super.stackTrace});
}

class CacheFailure extends BaseFailure {
  CacheFailure({required super.message, super.stackTrace});
}

class GeneralFailure extends BaseFailure {
  GeneralFailure({required super.message, super.stackTrace});
}
