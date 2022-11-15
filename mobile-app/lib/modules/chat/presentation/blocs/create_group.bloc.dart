import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tello_social_app/modules/chat/domain/entities/group.entity.dart';
import 'package:tello_social_app/modules/core/presentation/blocs/base_bloc.dart';
import 'package:tello_social_app/modules/core/presentation/either_stream_binder.dart';
import 'package:tello_social_app/modules/core/services/dialog_service.dart';
import 'package:tello_social_app/routes/app_routes.enum.dart';

import '../../domain/usecases/group_create.usecase.dart';
import 'fetch_grop_list_bloc.dart';

class CreateGroupBloc extends BaseBloc {
  final _titleCtrl = BehaviorSubject<String>();
  Stream<String> get titleStream => _titleCtrl.stream;
  // Stream<String> get titleStream => _titleCtrl.stream.transform(validateTitle);

  Function(String) get changeTitle => _titleCtrl.sink.add;
  Stream<bool> get canSubmit => Rx.combineLatest<String, bool>(
        [titleStream],
        (a) {
          return true;
        },
      );

  final validateTitle = StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    if (value.length > 5) {
      sink.add(value);
    } else {
      sink.addError('Enter a valid title');
    }
  });

  //===============
  late final GroupCreateUseCase useCase = Modular.get();
  late final _useCaseStreamBind = EitherStreamBinder<GroupEntity>();
  CreateGroupBloc() {}

  void setName() async {
    final String? name = await DialogService.showTextInputDialog(title: "Enter group name", hint: "group name");
    if (name != null && name.isNotEmpty) {
      changeTitle(name);
    }
  }

  String? Function()? _getAvataPathFunction;
  void setAvatarPathGetter(String? Function() getAvataPathFunction) {
    _getAvataPathFunction = getAvataPathFunction;
  }

  void action() async {
    /*final String? name = await DialogService.showTextInputDialog(title: "Enter group name", hint: "group name");
    if (name == null) {
      return;
    }*/

    final String? name = _titleCtrl.valueOrNull;

    if (name == null || name.length < 5) {
      showAlert('Enter a valid group name');
      return;
    }

    final GroupCreateUseCase useCase = Modular.get();

    final String? avatarPath = _getAvataPathFunction?.call();
    final params = CreateGroupParams(name: name, members: null, description: null, avatarPath: avatarPath);
    // final params = CreateGroupParams(name: name, members: []);
    setBusy(true);
    _useCaseStreamBind.callUseCase(() => useCase.call(params),
        onCompleted: (_) => setBusy(false),
        onFailure: (error) => showAlert(error),
        onSuccess: (data) {
          _onActionDone(data.id);
        });
  }

  void _onActionDone(String groupID) async {
    // await DialogService.simpleAlert(title: "Done", body: "Group created #$groupID");
    final FetchGroupListBloc fetchGroupListBloc = Modular.get();

    fetchGroupListBloc.loadData();

    Modular.to.pushReplacementNamed(AppRoute.groupDetail.withIdParam(groupID));

    // Modular.to.pop();
  }

  @override
  void dispose() {
    _useCaseStreamBind.dispose();
  }
}
