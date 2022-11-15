import 'package:tello_social_app/modules/common/api/response/response_status_code.dart';

import 'response_status.dart';

class ApiResponse {
  final ResponseStatus status;
  final int serverTimestamp;
  final dynamic data;

  bool get isFailedResponse => status.code != ResponseStatusCode.noError;
  ApiResponse({
    required this.status,
    required this.serverTimestamp,
    this.data,
  });

  factory ApiResponse.fromMap(Map<String, dynamic> map) {
    return ApiResponse(
        status: ResponseStatus.fromMap(map['status'] as Map<String, dynamic>),
        serverTimestamp: map['serverTimestamp'] as int,
        data: map["data"]);
  }

  @override
  String toString() => 'ApiResponseBase(status: $status, serverTimestamp: $serverTimestamp)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ApiResponse && other.status == status && other.serverTimestamp == serverTimestamp;
  }

  @override
  int get hashCode => status.hashCode ^ serverTimestamp.hashCode;
}
