import 'response_status_code.dart';

class ResponseStatus {
  final ResponseStatusCode code;
  final String message;
  ResponseStatus({
    required this.code,
    required this.message,
  });

  ResponseStatus copyWith({
    ResponseStatusCode? code,
    String? message,
  }) {
    return ResponseStatus(
      code: code ?? this.code,
      message: message ?? this.message,
    );
  }

  factory ResponseStatus.fromMap(Map<String, dynamic> map) {
    return ResponseStatus(
      code: ResponseStatusCode.fromCode(map['code'] as int),
      message: map['message'] as String? ?? "",
    );
  }
  @override
  String toString() => 'ResponseStatus(code: $code, message: $message)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ResponseStatus &&
        other.code == code &&
        other.message == message;
  }

  @override
  int get hashCode => code.hashCode ^ message.hashCode;
}
