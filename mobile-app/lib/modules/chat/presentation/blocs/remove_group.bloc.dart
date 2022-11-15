import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:tello_social_app/modules/chat/domain/usecases/group_delete.usecase.dart';
import 'package:tello_social_app/modules/core/presentation/blocs/base_bloc.dart';
import 'package:tello_social_app/modules/core/services/dialog_service.dart';

class RemoveGroupBloc extends BaseBloc {
  Future<void> action(String groupId) async {
    final GroupDeleteUseCase useCase = Modular.get();

    final response = await useCase.call(groupId);
    response.fold((l) {
      setBusy(false);
      showAlert(l.toString());
    }, (r) {
      setBusy(false);
      _onDone();
    });
  }

  void _onDone() async {
    showAlert("group has been removed", title: "Done");
    // final FetchGroupListBloc fetchGroupListBloc = Modular.get();
    // fetchGroupListBloc.loadData();
  }
}
