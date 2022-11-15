import 'dart:async';

import 'package:tello_social_app/modules/core/services/interfaces/icancel_token.dart';

abstract class IHttpClientService {
  void dispose();
  Future<dynamic> get(
    String url, {
    ICancelToken? cancelToken,
    Map<String, dynamic>? params,
  });
  Future<dynamic> post(
    String url, {
    ICancelToken? cancelToken,
    Map<String, dynamic>? params,
    dynamic postData,
    bool isJson = false,
    String? contentTypeHeader,
    StreamController<int>? uploadProgressCtrl,
  });
  Future<dynamic> put(String url,
      {ICancelToken? cancelToken, Map<String, dynamic>? params, dynamic postData, bool isJson = false});
  Future<dynamic> delete(String url,
      {ICancelToken? cancelToken, Map<String, dynamic>? params, dynamic postData, bool isJson = false});

  Future<dynamic> upload(
    String url, {
    required String filePath,
    Map<String, dynamic> dtMap,
    ICancelToken? cancelToken,
    Map<String, dynamic>? params,
    StreamController<int>? uploadProgressCtrl,
  });

  void setHeaders(Map<String, String> headers);
  void renmoveHeader(String key);
  void setBearerToken(String token);
  void clearBearerToken();
  String? getBearerToken();
  // Map<String, dynamic> get headers;
  void addCustomHeaderItem(String key, String value);
}
