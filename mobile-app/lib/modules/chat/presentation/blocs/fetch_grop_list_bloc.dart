import 'package:flutter_contacts/properties/group.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tello_social_app/modules/chat/domain/entities/group.entity.dart';
import 'package:tello_social_app/modules/core/presentation/action_state.dart';
import 'package:tello_social_app/modules/core/presentation/blocs/base_bloc.dart';
import 'package:tello_social_app/modules/core/presentation/either_stream_binder.dart';

import '../../domain/usecases/group_fetchlist.usecase.dart';
import '../../domain/usecases/group_set_active.usecase.dart';
import 'remove_group.bloc.dart';

class FetchGroupListBloc extends BaseBloc {
  late final _streamBinder = EitherStreamBinder<List<GroupEntity>>();

  late final GroupFetchListUseCase _useCase = Modular.get();
  late final GroupSetActiveUseCase groupSetActiveUseCase = Modular.get();

  Stream<ActionState<List<GroupEntity>>> get outStream =>
      _streamBinder.outStream;

  FetchGroupListBloc() {
    loadData();
  }
  List<GroupEntity>? get loadedValue => _streamBinder.loadedValue;
  Future<void> loadData() async {
    return _streamBinder.callUseCase(() => _useCase.call(null),
        forceLoading: true);
  }

  void actionSetActiveGroup(GroupEntity groupEntity) async {
    setBusy(true);
    final response = await groupSetActiveUseCase.call(groupEntity.id);
    if (response.isRight()) {
      List<GroupEntity> list = _streamBinder.loadedValue!;

      List<GroupEntity> listResetActive =
          list.map((e) => e.copyWith(isActive: false)).toList();
      _streamBinder.addLoadedValue(listResetActive);
      final GroupEntity updated = groupEntity.copyWith(isActive: true);
      updateWith(updated);
    }
    setBusy(false);
    // loadData();
  }

  void actionRemove(String groupId) async {
    setBusy(true);
    final RemoveGroupBloc bloc = Modular.get();
    await bloc.action(groupId);
    setBusy(false);
    loadData();
  }

  void updateWith(GroupEntity entityUpdated) {
    List<GroupEntity>? list = _streamBinder.loadedValue;
    if (list != null) {
      final int index =
          list.indexWhere((element) => element.id == entityUpdated.id);
      if (index != -1) {
        list[index] = list[index].copyWith(
            avatar: entityUpdated.avatar,
            name: entityUpdated.name,
            membersCount: entityUpdated.membersCount,
            isActive: entityUpdated.isActive);

        _streamBinder.addLoadedValue(list);
      }
    }
  }

  void dipose() {
    _streamBinder.dispose();
  }
}
