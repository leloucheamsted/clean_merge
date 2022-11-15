import 'dart:developer';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tello_social_app/modules/core/services/dialog_service.dart';
import 'package:tello_social_app/modules/user/domain/entities/app_user.dart';
import 'package:tello_social_app/modules/user/domain/usecases/session_read_phone_number.usecase.dart';

import '../../../routes/app_routes.enum.dart';
import '../../chat/domain/entities/group.entity.dart';
import '../../chat/presentation/blocs/fetch_grop_list_bloc.dart';
import '../../user/domain/usecases/session_read_token.usecase.dart';
import '../../user/domain/usecases/user_get_details.usecase.dart';
import '../services/interfaces/ihttpclient_service.dart';

class AppStateBloc {
  late final FetchGroupListBloc fetchGroupListBloc = Modular.get();
  late final UserGetDetailsUseCase _userGetDetailsUseCase = Modular.get();
  late final SessionReadPhoneNumberUseCase sessionReadPhoneNumberUseCase = Modular.get();
  late final SessionReadTokenUseCase sessionReadTokenUseCase = Modular.get();
  // late final ContactSyncService contactSyncService = Modular.get();

  String? _currentUserPhoneNumber;
  String? get currentUserPhoneNumber => _currentUserPhoneNumber;
  AppUser? appUser;

  Future<String?> _getActiveGroupId() async {
    // return null;
    await fetchGroupListBloc.loadData();
    final list = fetchGroupListBloc.loadedValue;
    if (list != null) {
      final GroupEntity? activeGroup = list.firstWhereOrNull((element) => element.isActive);
      if (activeGroup != null) {
        return activeGroup.id;
      }
    }
    return null;
  }

  Future<void> bootstrap() async {
    final responsePhone = await sessionReadPhoneNumberUseCase.call(null);

    responsePhone.fold((l) => _log(l.toString()), (r) {
      _currentUserPhoneNumber = r;
    });

    final responseToken = await sessionReadTokenUseCase.call(null);
    responseToken.fold((l) => _log(l.toString()), (r) {
      _onTokenResult(r);
    });

    // contactSyncService.actionSync();
  }

  Future<void> getAppUser() async {
    final response = await _userGetDetailsUseCase.call(null);
    response.fold((l) => null, (r) {
      appUser = r;
      log("Hi ${appUser!.displayName}");

      DialogService.showToast(msg: "Hi ${appUser!.displayName}");
    });
  }

  void _onTokenResult(String? token) async {
    if (token == null) {
      Modular.to.pushReplacementNamed(AppRoute.auth.path);
      return;
    }

    log("token $token");
    IHttpClientService httpClientService = Modular.get();
    httpClientService.setBearerToken(token);

    await getAppUser();

    final String? activeGroupId = await _getActiveGroupId();
    Modular.to.pushReplacementNamed(
        activeGroupId == null ? AppRoute.home.path : AppRoute.groupDetail.withIdParam(activeGroupId));
  }

  void _log(String msg) {
    log("$runtimeType.$msg");
  }
}
