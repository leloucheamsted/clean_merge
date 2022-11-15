import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modular_test/modular_test.dart';
import 'package:tello_social_app/modules/core/core.module.dart';
// import 'package:tello_social_app/modules/core/presentation/blocs/auth_bloc.dart';
import 'package:tello_social_app/modules/user/domain/usecases/session_read_token.usecase.dart';
import 'package:tello_social_app/modules/user/domain/usecases/session_save_token.usecase.dart';
import 'package:tello_social_app/modules/user/test.module.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  late SessionReadTokenUseCase sessionReadUseCase;
  late SessionSaveTokenUseCase sessionSaveUseCase;

  setUp(() {
    initModule(CoreModule());
    // initModule(UserModule());

    sessionReadUseCase = Modular.get();
    sessionSaveUseCase = Modular.get();
  });

  test("test save and read token", () async {
    const String testToken = "testToken123456";

    final saveResponse = await sessionSaveUseCase.call(testToken);

    final bool isSaveSuccess = saveResponse.isRight();

    saveResponse.fold((l) => print("failed $l"), (r) {
      print("success");
    });

    expect(isSaveSuccess, true);

    final readResponse = await sessionReadUseCase.call(null);

    // final bool isReadSuccess = readResponse.isRight();

    final String? savedToken = readResponse.getOrElse(() => throw "No saved Token");

    expect(savedToken, testToken);
  });
}
