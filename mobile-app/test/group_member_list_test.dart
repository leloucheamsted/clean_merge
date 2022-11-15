import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modular_test/modular_test.dart';
import 'package:tello_social_app/modules/chat/domain/usecases/group_fetchlist.usecase.dart';
import 'package:tello_social_app/modules/chat/group.module.dart';
import 'package:tello_social_app/modules/core/core.module.dart';
// import 'package:tello_social_app/modules/core/presentation/blocs/auth_bloc.dart';
import 'package:tello_social_app/modules/user/domain/usecases/session_read_token.usecase.dart';
import 'package:tello_social_app/modules/user/domain/usecases/session_save_token.usecase.dart';
import 'package:tello_social_app/modules/core/services/implementations/http/diohttpclient_service.dart';
import 'package:tello_social_app/modules/core/services/interfaces/ihttpclient_service.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();

  TestWidgetsFlutterBinding.ensureInitialized();

  late IHttpClientService httpClientService;

  const String tokenSocial =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyMmIxYTBiMDM5ZDI0Njc0OTJkNGNkZjdmNDcwZmNlYiIsInVuaXF1ZV9uYW1lIjoiMjJiMWEwYjAzOWQyNDY3NDkyZDRjZGY3ZjQ3MGZjZWIiLCJqdGkiOiIzNzk3YThhZC1lNWNmLTRhY2ItYTViYS04ZTlmZjU2OTNhNDMiLCJpYXQiOiIxNjY0MjM0MTkwIiwiYXVkIjoiNDEwMzczIiwibmJmIjoxNjY0MjM0MTkwLCJleHAiOjE2NjYzMDc3OTAsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0OjcyNjMifQ.up1gkXxuN4fk11wPCsOl-KJXoS6f1hBpeK9-Z0sbPS4";

  setUp(() {
    /*final Dio dioClient = Dio(
      BaseOptions(
        baseUrl: 'https://api.dev.bazzptt.com',
        headers: {
          "content-type": "application/json",
        },
      ),
    );
    httpClientService = DioHttpClientService(dio: dioClient);
    httpClientService.setBearerToken(tokenSocial);
    */
    // initModule(CoreModule());
    initModule(GroupModule());
  });

  test("test group members", () async {
    // initModule(GroupModule());

    final GroupFetchListUseCase fetchListUseCase = Modular.get();

    final response = await fetchListUseCase.call();

    final bool isSuccess = response.isRight();

    response.fold((l) => print(l), (r) => print(r));

    expect(isSuccess, true);
  });
}
