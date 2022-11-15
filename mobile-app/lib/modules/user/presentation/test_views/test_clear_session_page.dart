import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tello_social_app/modules/common/widgets.dart';
import 'package:tello_social_app/modules/core/services/interfaces/ihttpclient_service.dart';
import 'package:tello_social_app/modules/user/domain/usecases/session_clear.usecase.dart';
import 'package:tello_social_app/modules/user/domain/usecases/session_read_token.usecase.dart';
import 'package:tello_social_app/routes/app_routes.enum.dart';

class TestClearSession extends StatelessWidget {
  const TestClearSession({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final IHttpClientService httpClientService = Modular.get();
    return Scaffold(
      appBar: AppBar(
        title: const Text("TestClearSession"),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SimpleButton(
        content: "Clear Session",
        onTap: _onAction,
      ),
    );
  }

  void _onAction() async {
    final SessionClearUseCase useCase = Modular.get();
    await useCase.call(null);
    Modular.to.navigate(AppRoute.auth.path);
    // Modular.to.pop();
  }
}
