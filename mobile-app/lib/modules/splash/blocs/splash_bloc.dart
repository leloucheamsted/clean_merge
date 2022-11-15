import 'package:flutter_modular/flutter_modular.dart';
import 'package:tello_social_app/modules/chat/presentation/blocs/fetch_grop_list_bloc.dart';
import 'package:tello_social_app/modules/core/blocs/app_state_bloc.dart';
import 'package:tello_social_app/modules/user/domain/usecases/session_read_token.usecase.dart';

class SplashBloc {
  // late final SessionExistsUseCase useCase = Modular.get();
  late final SessionReadTokenUseCase useCase = Modular.get();
  late final FetchGroupListBloc fetchGroupListBloc = Modular.get();
  late final AppStateBloc appStateBloc = Modular.get();
  // late final _useCaseStreamBind = EitherStreamBinder();

  bool _isBusy = false;
  SplashBloc();

  void checkTokenAndRedirect() async {
    if (_isBusy) return;

    _isBusy = true;

    await appStateBloc.bootstrap();
  }

  void dispose() {
    // _useCaseStreamBind.dispose();
  }
}
