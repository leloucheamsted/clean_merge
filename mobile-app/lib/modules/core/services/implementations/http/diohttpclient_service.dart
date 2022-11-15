import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:tello_social_app/modules/core/services/interfaces/icancel_token.dart';

import '../../interfaces/ihttpclient_service.dart';
import 'dio_log_itnterceptor.dart';
import 'exceptions.dart';

enum RestAction {
  get,
  post,
  put,
  delete,
}

class DioHttpClientService implements IHttpClientService {
  // final Dio? client;
  // late Dio _dio;
  final Dio dio;

  //TODO: refactor inject session on app startup
  // final SessionReadUseCase sessionReadUseCase;
  final Function(Map)? customValidateResponse;

  final Function? customErrorParser;
  Map<String, dynamic>? _customHeaders;

  DioHttpClientService({
    // this.client,
    required this.dio,
    // required this.sessionReadUseCase,
    this.customValidateResponse,
    this.customErrorParser,
  }) {

    log("DioHttpClientService.create");
    dio.options.headers = {
      HttpHeaders.acceptHeader: '*/*',
    };
    dio.interceptors.add(DioLogInterceptor());
  }
  /*void _initAsync() async {
    final response = await sessionReadUseCase.call(null);
    response.fold((l) => log("httpClientTokenRead.failed $l"), (r) {
      log("httpClientTokenRead.done $r");
      if (r != null) {
        setBearerToken(r);
      }
    });
  }*/

  Future<dynamic> _fetchApiPostOrDelete(
    String url, {
    CancelToken? cancelToken,
    dynamic postData,
    bool isJson = true,
    // bool isUpload = false,
    StreamController<int>? uploadProgressCtrl,
    Map<String, dynamic>? params,
    RestAction restAction = RestAction.post,
    String? contentTypeHeader,
    Options? options,
  }) {
    /*final options = Options(
      headers: {
        HttpHeaders.contentTypeHeader: isJson ? "application/json" : "application/x-www-form-urlencoded",
      },
    );*/

    if (postData != null && postData is FormData) {
      //do nothing the proper header will be set by dio plugin internally _ALL
    } else {
      final headers = {
        HttpHeaders.contentTypeHeader:
            isJson ? "application/json" : contentTypeHeader ?? "application/x-www-form-urlencoded",
      };
      setHeaders(headers);
    }

    // options = _mergedHeaders(headers)
    // contentType:isJson ? "application/json" : "application/x-www-form-urlencoded");
    return _fetchApiRestAction(
      url,
      cancelToken: cancelToken,
      // restAction: isPost ? RestAction.post : RestAction.del,
      restAction: restAction,
      // httpClient: httpClient,
      options: options,
      // isUpload: isUpload,
      params: params,
      uploadProgressCtrl: uploadProgressCtrl,
      data: postData,
    );
  }

  @override
  void renmoveHeader(String headerKey) {
    _customHeaders?.removeWhere((key, value) => key == headerKey);
    dio.options.headers.removeWhere((key, value) => key == headerKey);
  }

  @override
  void setHeaders(Map<String, dynamic> headers) {
    _customHeaders = headers;
    dio.options.headers.addAll(headers);
    // dio.options.headers = headers;
  }

  Map<String, String> _mergedHeaders(Map<String, String>? headers) => {...?_customHeaders, ...?headers};

  Future<dynamic> _fetchApiRestAction(
    String url, {
    CancelToken? cancelToken,
    RestAction restAction = RestAction.get,
    Options? options,
    dynamic data,
    Map<String, dynamic>? params,
    // bool isUpload = false,
    StreamController<int>? uploadProgressCtrl,
  }) async {
    dynamic responseJson;

    url = Uri.encodeFull(url);

    try {
      final Response response = await dio.request(url,
          data: data,
          options: (options ?? Options())..method = restAction.name,
          cancelToken: cancelToken,
          queryParameters: params,
          onReceiveProgress: uploadProgressCtrl == null
              ? null
              : (received, total) {
                  log("r: $received t: $total");

                  uploadProgressCtrl.sink.add(total <= 0 ? -1 : ((received / total) * 100).round());
                });
      /*final Response response = restAction == RestAction.get || restAction == RestAction.put
          // ? await dio.fetch(url, queryParameters: params, cancelToken: cancelToken)
          ? await dio.request(
              url,
              data: data,
              options: (options ?? Options())..method = restAction.name,
              cancelToken: cancelToken,
              queryParameters: params,
            )
          : restAction == RestAction.post
              ? await dio.post(url,
                  data: data,
                  options: options,
                  cancelToken: cancelToken,
                  queryParameters: params,
                  onReceiveProgress: uploadProgressCtrl == null
                      ? null
                      : (received, total) {
                          log("r: $received t: $total");

                          uploadProgressCtrl.sink.add(total <= 0 ? -1 : ((received / total) * 100).round());
                        })
              : await dio.delete(
                  url,
                  data: data,
                  queryParameters: params,
                  cancelToken: cancelToken,
                );*/
      ;

      responseJson = _parseApiResponse(response);

      // responseJson = json.decode(response.body);
      // } on SocketException {
      // throw ErrorNoInternetConnection();
      // throw FetchDataException("no internet connection");
    } on DioError catch (e) {
      // log(_dio2curl(e.requestOptions));
      if (CancelToken.isCancel(e)) {
        responseJson = null;
      } else {
        if (e.error is SocketException) {
          throw ErrorNoInternetConnection();
        }
        if (e.type == DioErrorType.connectTimeout || e.type == DioErrorType.receiveTimeout) {
          throw ErrorTimeoutConnection();
        } else {
          // throw ErrorNoInternetConnection();
          if (customErrorParser != null) {
            throw Exception(customErrorParser!(e.response));
          } else {
            throw Exception(e.response);
          }

          // rethrow;
        }
      }
    } catch (e, s) {
      rethrow;
      // throw UnHandledHttpException(e, s);
    }
    return responseJson;
  }

  dynamic _parseApiResponse(Response response) {
    // throw ApiException("force update message from server");

    if (response.statusCode! >= 200 && response.statusCode! <= 299) {
      return response.data;
    }

    switch (response.statusCode) {
      case 200:
      case 204:
        return response.data;
      // var parsedJson = json.decode(response.data.toString());
      // var parsedJson = response.data;
      // _validateReponse(parsedJson);
      // return parsedJson["msg"];
      case 400:
        throw BadRequestException(response.data.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.data.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  void _validateReponse(Map dataMap) {
    if (customValidateResponse != null) {
      customValidateResponse!.call(dataMap);
    } else {
      /*if (dataMap["st"] != 1) {
        throw ApiException(dataMap["msg"] ?? dataMap["err"]);
      }*/
    }
  }

  @override
  Future upload(
    String url, {
    required String filePath,
    String? fileName,
    Map<String, dynamic>? dtMap,
    Map<String, dynamic>? params,
    ICancelToken? cancelToken,
    StreamController<int>? uploadProgressCtrl,
  }) async {
    fileName ??= filePath.split("/").last;

    final filePart = await MultipartFile.fromFile(
      filePath,
      filename: fileName,
    );
    final Map<String, dynamic> postData = dtMap ?? {};
    postData["File"] = filePart;

    final Options options = Options(
      // responseType: ResponseType.bytes,
      followRedirects: true,
    );

    return _fetchApiPostOrDelete(url,
        cancelToken: cancelToken as CancelToken?,
        postData: FormData.fromMap(postData),
        restAction: RestAction.post,
        // isJson: true,
        // isUpload: true,
        params: params,
        // options: options,
        uploadProgressCtrl: uploadProgressCtrl);
  }

  @override
  Future get(String url, {ICancelToken? cancelToken, Map<String, dynamic>? params}) {
    return _fetchApiRestAction(url,
        cancelToken: cancelToken as CancelToken?, restAction: RestAction.get, params: params);
  }

  @override
  Future post(
    String url, {
    ICancelToken? cancelToken,
    postData,
    Map<String, dynamic>? params,
    bool isJson = true,
    String? contentTypeHeader,
    StreamController<int>? uploadProgressCtrl,
  }) {
    return _fetchApiPostOrDelete(
      url,
      cancelToken: cancelToken as CancelToken?,
      postData: postData,
      params: params,
      isJson: isJson,
      restAction: RestAction.post,
      contentTypeHeader: contentTypeHeader,
      uploadProgressCtrl: uploadProgressCtrl,
    );
  }

  @override
  Future put(String url, {ICancelToken? cancelToken, postData, Map<String, dynamic>? params, bool isJson = true}) {
    return _fetchApiPostOrDelete(url,
        cancelToken: cancelToken as CancelToken?,
        postData: postData,
        params: params,
        isJson: isJson,
        restAction: RestAction.put);
  }

  @override
  Future delete(String url, {ICancelToken? cancelToken, postData, Map<String, dynamic>? params, bool isJson = true}) {
    return _fetchApiPostOrDelete(url,
        cancelToken: cancelToken as CancelToken?,
        postData: postData,
        params: params,
        isJson: isJson,
        restAction: RestAction.delete);
  }

  @override
  void setBearerToken(String token) {
    addCustomHeaderItem(HttpHeaders.authorizationHeader, 'Bearer $token');
  }

  @override
  void clearBearerToken() {
    dio.options.headers[HttpHeaders.authorizationHeader] = null;
  }

  @override
  String? getBearerToken() {
    // final regExp = RegExp(r'^(?<type>.+?)\s+(?<token>.+?)$');
    final regExp = RegExp(r'^Bearer\s+(?<token>.+?)$');
    final String authHeader = dio.options.headers[HttpHeaders.authorizationHeader];
    RegExpMatch? match = regExp.firstMatch(authHeader);
    String? parsedTokenValue = match?.namedGroup("token");
    return parsedTokenValue;
  }

  @override
  void addCustomHeaderItem(String key, String value) {
    dio.options.headers[key] = value;
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
