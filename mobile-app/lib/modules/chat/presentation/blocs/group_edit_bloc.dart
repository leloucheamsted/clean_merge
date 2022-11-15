import 'package:flutter_modular/flutter_modular.dart';
import 'package:tello_social_app/modules/chat/domain/entities/group.entity.dart';
import 'package:tello_social_app/modules/chat/domain/usecases/group_rename.usecase.dart';
import 'package:tello_social_app/modules/chat/domain/usecases/group_value_params.dart';
import 'package:tello_social_app/modules/chat/presentation/blocs/group_detail_bloc.dart';
import 'package:tello_social_app/modules/core/error/failure.dart';
import 'package:tello_social_app/modules/core/presentation/action_state.dart';
import 'package:tello_social_app/modules/core/presentation/blocs/base_bloc.dart';
import 'package:tello_social_app/modules/core/presentation/either_stream_binder.dart';
import 'package:tello_social_app/modules/core/services/dialog_service.dart';

import '../../domain/entities/group_member.entity.dart';
import '../../domain/usecases/group_delete.usecase.dart';
import '../../domain/usecases/group_find_by_id.usecase.dart';
import '../../domain/usecases/group_remove_member.usecase.dart';
import '../../domain/usecases/input_group_member_usecase.dart';
import 'fetch_grop_list_bloc.dart';

class GroupEditBloc extends BaseBloc {
  final GroupDetailBloc _groupDetailBloc = Modular.get();

  late final _fetchGroupStreamBinder = EitherStreamBinder<GroupEntity>();

  late final GroupFindByIdUseCase _fetchGroupUseCase = Modular.get();

  late final GroupDeleteUseCase groupDeleteUseCase = Modular.get();
  late final GroupRemoveMemberUseCase groupRemoveMemberUseCase = Modular.get();
  late final GroupRenameUseCase groupRenameUseCase = Modular.get();

  late final _addMemberStreamBinder = EitherStreamBinder();

  Stream<List<GroupMemberEntity>> get outMemberStream =>
      _fetchGroupStreamBinder.outDataStream.map((event) => event.members);

  // Stream<List<String>> get outMembersPhoneNumberStream => _fetchGroupStreamBinder.outDataStream
  //     .map((event) => event.members.map((e) => e.phoneNumber.replaceAll(" ", "")).toList());

  Stream<List<String>> get outMembersPhoneNumberStream =>
      _fetchGroupStreamBinder.outDataStream.map((event) => event.members.map((e) => e.phoneNumber).toList());

  List<GroupMemberEntity>? get memberList => _fetchGroupStreamBinder.loadedValue?.members;

  final String groupId;
  GroupEditBloc(this.groupId) {
    loadData();
  }

  Stream<ActionState<GroupEntity>> get outStream => _fetchGroupStreamBinder.outStream;
  Stream<ActionState> get outStreamAddMember => _addMemberStreamBinder.outStream;

  void loadData() {
    _fetchGroupStreamBinder.callUseCase(() => _fetchGroupUseCase.call(groupId), forceLoading: true);
  }

  void actionRename() async {
    final String? name = await DialogService.showTextInputDialog(
        title: "Enter group name", hint: "group name", defaultValue: _fetchGroupStreamBinder.loadedValue?.name);
    if (name == null) {
      return;
    }

    try {
      setBusy(true);

      final result = await groupRenameUseCase.call(GroupValueParams(groupId: groupId, value: name));

      result.fold((l) => onRenameDone(failure: l), (r) {
        //   _loadData();
        final GroupEntity entity = GroupEntity.fromMap(r as Map<String, dynamic>);

        final GroupEntity entityUpdated = _fetchGroupStreamBinder.loadedValue!.copyWith(
          name: entity.name,
        );
        _onEntityUpdated(entityUpdated);
        onRenameDone();
        // DialogService.showToast(msg: "User removed $phoneNumber");
      });
    } catch (e) {
      showAlert(e.toString());
    }
  }

  void onAvatarUploadFinish(String? url) {
    final GroupEntity entityUpdated = _fetchGroupStreamBinder.loadedValue!.copyWith(
      avatar: url,
    );
    _onEntityUpdated(entityUpdated);
  }

  void _onEntityUpdated(GroupEntity entityUpdated) {
    _groupDetailBloc.updateWith(entityUpdated);
    _fetchGroupStreamBinder.addLoadedValue(entityUpdated);
  }

  void onRenameDone({IFailure? failure, GroupEntity? entity}) {
    setBusy(false);
    if (failure != null) {
      showAlert(failure.toString());
    } else {
      // _groupDetailBloc.updateWith(entity!);
      // loadData();
      DialogService.showToast(msg: "Group renamed");
    }
  }

  void actionDeleteMember(String phoneNumber) async {
    //TODO: remove to GroupEditBloc
    try {
      DialogService.showLoading();

      final result =
          await groupRemoveMemberUseCase.call(InputGroupMemberUsecase(groupId: groupId, phoneNumber: phoneNumber));

      result.fold((l) => onRemoveDone(failure: l), (r) {
        //   _loadData();
        _onEntityUpdated(r);
        onRemoveDone();
        // DialogService.showToast(msg: "User removed $phoneNumber");
      });
    } catch (e) {
      showAlert(e.toString());
    }
  }

  void actionDeleteGroup() async {
    try {
      setBusy(true);

      final result = await groupDeleteUseCase.call(groupId);

      result.fold((l) => onRemoveDone(failure: l), (r) {
        //   _loadData();
        onRemoveDone(isMemberRemove: false);
        // DialogService.showToast(msg: "User removed $phoneNumber");
      });
    } catch (e) {
      showAlert(e.toString());
    }
  }

  void onRemoveDone({IFailure? failure, bool isMemberRemove = true}) {
    setBusy(false);
    if (failure != null) {
      showAlert(failure.toString());
    } else {
      if (isMemberRemove) {
        // loadData();
        DialogService.showToast(msg: "User removed");
      } else {
        final FetchGroupListBloc fetchGroupListBloc = Modular.get();
        fetchGroupListBloc.loadData();
        DialogService.showToast(msg: "Group removed");
        Modular.to.pop();
        Modular.to.pop();
      }
    }
  }

  @override
  void dispose() {
    _fetchGroupStreamBinder.dispose();
    _addMemberStreamBinder.dispose();
  }
}
