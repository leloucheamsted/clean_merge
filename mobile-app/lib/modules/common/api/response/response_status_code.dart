import 'package:collection/collection.dart';

enum ResponseStatusCode {
  unMatched(-1, "unMatched"),
  noError(0, "NoError"),
  unknownError(1, "UnknownError"),
  validationError(2, "ValidationError"),
  authorization(3, "Authorization"),
  wrongAuthorization(4, "WrongAuthorization"),
  permissionDenied(5, "PermissionDenied"),
  notSuccessfulResult(6, "NotSuccessfulResult"),
  noChanges(7, "NoChanges"),
  maxLimit(8, "MaxLimit"),
  systemShiftEnded(98, "SystemShiftEnded"),
  ;

  const ResponseStatusCode(this.code, this.description);
  final int code;
  final String description;

  @override
  String toString() {
    return "ResponseStatus($code,$description)";
  }

  factory ResponseStatusCode.fromCode(int code) {
    final ResponseStatusCode? res = ResponseStatusCode.values.firstWhereOrNull((element) => element.code == code);

    if (res != null) {
      return res;
    }
    throw Exception("UnknownResponseStatus $code");
    // return res ?? ResponseStatus.unMatched;
  }
}
