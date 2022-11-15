import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:tello_social_app/modules/core/repositories/base_repo.dart';

class DioLogInterceptor implements Interceptor {
  void _log(String msg) {
    //TODO: replace with core log custom function
    log("DioLog. $msg");
  }

  ///错误数据采集
  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    _log(err.toString());
    _log("${err.response?.data}");

    log(_dio2curl(err.requestOptions));
    return handler.next(err);
  }

  ///请求体数据采集
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // return handler.next(options);
    // _log("onRequest ${options.uri}");

    // options.headers.remove(Headers.contentLengthHeader);
    // log(_dio2curl(options));
    return handler.next(options);
  }

  ///响应体数据采集
  @override
  Future onResponse(Response response, ResponseInterceptorHandler handler) async {
    _log("onResponse ${response.requestOptions.uri}");

    return handler.next(response);
  }

  String __dio2curl(RequestOptions options) {
    String cmd = "curl";

    String header = options.headers
            .map((key, value) {
              if (key == "content-type" && value.toString().indexOf("multipart/form-data") != -1) {
                value = "multipart/form-data;";
              }
              return MapEntry(key, "-H '$key: $value'");
            })
            .values
            .join(" ") ??
        "";
    String url = "${options.baseUrl ?? ""}${options.path}";
    if (options.queryParameters.isNotEmpty) {
      String query = options.queryParameters
          .map((key, value) {
            return MapEntry(key, "$key=$value");
          })
          .values
          .join("&");

      url += (url.indexOf("?") != -1) ? query : "?$query";
    }
    if (options.method == "GET") {
      cmd += " $header '$url'";
    } else {
      Map<String, dynamic> files = {};
      String postData = "-d ''";
      if (options != null) {
        if (options.cancelToken is FormData) {
          FormData fdata = options.data as FormData;
          fdata.files.forEach((element) {
            MultipartFile file = element.value;
            files[element.key] = "@${file.filename}";
          });
          fdata.fields.forEach((element) {
            files[element.key] = element.value;
          });
          if (files.length > 0) {
            postData = files.map((key, value) => MapEntry(key, "-F '$key=$value'")).values.join(" ");
          }
        } else if (options.data is Map<String, dynamic>) {
          files.addAll(options.data);

          if (files.length > 0) {
            postData = "-d '${json.encode(files).toString()}'";
          }
        }
      }

      String method = options.method.toString();
      cmd += " -X $method $postData $header '$url'";
    }

    return cmd;
  }

  String _dio2curl(RequestOptions options) {
    List<String> components = ['curl -i'];
    if (options.method.toUpperCase() != 'GET') {
      components.add('-X ${options.method}');
    }

    options.headers.forEach((k, v) {
      if (k != 'Cookie') {
        components.add('-H "$k: $v"');
      }
    });

    if (options.data != null) {
      // FormData can't be JSON-serialized, so keep only their fields attributes
      dynamic optionsData;
      if (options.data is FormData) {
        // options.data = Map.fromEntries(options.data.fields);//_ALL messed up code
        optionsData = Map.fromEntries(options.data.fields); //_ALL messed up code
      } else {
        optionsData = options.data;
      }

      final data = json.encode(optionsData);
      // final data = json.encode(options.data).replaceAll('"', '\\"');
      components.add("-d '$data'");
    }

    components.add('"${options.uri.toString()}"');

    return components.join(" ");
    // return components.join("\n\n");
    // return components.join(' \\\n\t');
  }
}
