import 'package:flutter_modular/flutter_modular.dart';
import 'package:tello_social_app/modules/core/blocs/app_state_bloc.dart';
import 'package:tello_social_app/modules/user/domain/usecases/user_rename.usecase.dart';

import '../../../../routes/app_routes.enum.dart';
import '../../../core/presentation/either_stream_binder.dart';
import '../../../core/services/dialog_service.dart';
import '../../../core/services/implementations/http/diohttpclient_service.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/usecases/session_clear.usecase.dart';
import '../../domain/usecases/user_get_details.usecase.dart';

class UserProfileBloc {
  late final fetchUserDetailStreamBinder = EitherStreamBinder<AppUser?>();
  late final UserGetDetailsUseCase _userGetDetailsUseCase = Modular.get();
  late final UserRenameUseCase _userRenameUseCase = Modular.get();
  late final AppStateBloc _appStateBloc = Modular.get();

  AppUser? get currentUser => fetchUserDetailStreamBinder.loadedValue;
  void setDisplayName() async {
    final String? name = await DialogService.showTextInputDialog(
      title: "Enter display name",
      hint: "nickname",
      defaultValue: currentUser?.displayName,
    );
    if (name == null || name == currentUser?.displayName) {
      return;
    }
    try {
      final res = await _userRenameUseCase.call(name);
      res.fold((l) => _showAlert(l.toString()), (r) {
        loadData();
        _showAlert("Done");
      });
    } catch (e) {
      _showAlert(e.toString());
    }
  }

  void _showAlert(String msg) {
    DialogService.simpleAlert(title: "Alert", body: msg);
  }

  void actionLogOut() async {
    DialogService.showLoading();
    final DioHttpClientService httpClientService = Modular.get();
    httpClientService.clearBearerToken();
    final SessionClearUseCase useCase = Modular.get();
    await useCase.call(null);
    DialogService.closeLoading();
    Modular.to.navigate(AppRoute.auth.path);
    // Modular.to.pop();
  }

  void dispose() {
    fetchUserDetailStreamBinder.dispose();
  }

  void loadData() {
    fetchUserDetailStreamBinder.callUseCase(
      () => _userGetDetailsUseCase.call(null),
      forceLoading: true,
      onSuccess: (data) {
        _appStateBloc.appUser = data;
      },
    );
  }
}
