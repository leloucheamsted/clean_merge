import 'dart:developer';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:tello_social_app/modules/chat/domain/entities/group.entity.dart';
import 'package:tello_social_app/modules/chat/domain/entities/group_ptt_member.entity.dart';
import 'package:tello_social_app/modules/chat/domain/usecases/group_attach.usecase.dart';
import 'package:tello_social_app/modules/chat/domain/usecases/group_detach.usecase.dart';
import 'package:tello_social_app/modules/chat/domain/usecases/group_value_params.dart';
import 'package:tello_social_app/modules/contact/domain/entities/contact.entity.dart';
import 'package:tello_social_app/modules/contact/presentation/pages/contact_list.page.dart';
import 'package:tello_social_app/modules/core/error/failure.dart';
import 'package:tello_social_app/modules/core/presentation/action_state.dart';
import 'package:tello_social_app/modules/core/presentation/either_stream_binder.dart';
import 'package:tello_social_app/modules/core/services/dialog_service.dart';
import 'package:tello_social_app/modules/core/usecases/iusecase.dart';
import 'package:tello_social_app/routes/app_routes.enum.dart';

import '../../domain/entities/group_member.entity.dart';
import '../../domain/usecases/group_add_member.usecase.dart';
import '../../domain/usecases/group_find_by_id.usecase.dart';
import '../../domain/usecases/group_remove_member.usecase.dart';
import '../../domain/usecases/input_group_member_usecase.dart';
import 'fetch_grop_list_bloc.dart';

class GroupDetailBloc {
  late final _attachStreamBinder = EitherStreamBinder<List<GroupPttMemberEntity>>();

  late final _fetchGroupStreamBinder = EitherStreamBinder<GroupEntity>();

  final FetchGroupListBloc fetchGroupListBloc = Modular.get();
  late final GroupFindByIdUseCase _fetchGroupUseCase = Modular.get();

  late final GroupAddMemberUseCase addMemberUseCase = Modular.get();
  late final GroupRemoveMemberUseCase groupRemoveMemberUseCase = Modular.get();

  late final _addMemberStreamBinder = EitherStreamBinder();

  Stream<List<GroupMemberEntity>> get outMemberStream =>
      _fetchGroupStreamBinder.outDataStream.map((event) => event.members);

  // Stream<List<String>> get outMembersPhoneNumberStream => _fetchGroupStreamBinder.outDataStream
  //     .map((event) => event.members.map((e) => e.phoneNumber.replaceAll(" ", "")).toList());

  Stream<List<String>> get outMembersPhoneNumberStream =>
      _fetchGroupStreamBinder.outDataStream.map((event) => event.members.map((e) => e.phoneNumber).toList());

  List<GroupMemberEntity>? get memberList => _fetchGroupStreamBinder.loadedValue?.members;

  GroupDetailBloc() {
    // outMembersPhoneNumberStream.listen(print);
  }
  String? _groupId;
  void setGroupId(String id) {
    _groupId = id;
  }

  Stream<ActionState<GroupEntity>> get outStream => _fetchGroupStreamBinder.outStream;
  Stream<ActionState> get outStreamAddMember => _addMemberStreamBinder.outStream;

  void loadData() {
    _fetchGroupStreamBinder.callUseCase(() => _fetchGroupUseCase.call(_groupId!), forceLoading: false);
  }

  void actionAttach(String phoneNumber, bool flag) async {
    late final IUseCase<GroupEntity, GroupValueParams> useCase =
        flag ? Modular.get<GroupAttachUseCase>() : Modular.get<GroupDetachUseCase>();

    final GroupValueParams params = GroupValueParams(groupId: _groupId!, value: phoneNumber);

    _setBusy(true);
    final responseEither = await useCase.call(params);

    responseEither.fold((l) => onActionDone(failure: l), (r) => onActionDone(result: r));

    // _attachStreamBinder.callUseCase(() => useCase.call(params), flagLoading: true);
  }

  void actionAddContact() async {
    final ContactListPageParams pageParams = ContactListPageParams(
      // members: memberList == null ? [] : memberList!.map((e) => e.phoneNumber.replaceAll(" ", "")).toList(),
      membersPhoneStream: outMembersPhoneNumberStream,
      onSelectContact: actionAddOrRemove,
    );
    Modular.to.pushNamed<ContactEntity>(AppRoute.contacts.path, arguments: pageParams);
  }

  void actionSelectContact() async {
    final response = await Modular.to.pushNamed<ContactEntity>(AppRoute.contacts.path);
    if (response == null) {
      return;
    }
    log("onContactSelect $response");

    final GroupAddMemberUseCase groupAddUserUseCase = Modular.get();
    _setBusy(true);
    _addMemberStreamBinder.callUseCase(
        () => groupAddUserUseCase.call(InputGroupMemberUsecase(groupId: _groupId!, phoneNumber: response.phoneNumber)),
        // onCompleted: (_) => _setBusy(false),
        onFailure: (error) => DialogService.simpleAlert(title: "Fail", body: error),
        onSuccess: (data) {
          //TODO: add member in memory without api fetch _ALL
          loadData();
          DialogService.simpleAlert(title: "Done", body: data.toString());
        });
  }

  //TODO: clear space
  bool isContactIsAGroupMember(ContactEntity contactEntity) => memberList!
      .any((element) => element.phoneNumber.replaceAll(" ", "") == contactEntity.phoneNumber.replaceAll(" ", ""));
  // memberList!.any((element) => element.phoneNumber == contactEntity.phoneNumber);

  void actionAddOrRemove(ContactEntity contactEntity) {
    final bool contains = isContactIsAGroupMember(contactEntity);
    _setBusy(true);
    contains ? _actionRemove(contactEntity.phoneNumber) : _actionAdd(contactEntity.phoneNumber);
  }

  void _actionAdd(String phoneNumber) async {
    if (memberList!.length == 8) {
      // _isEditable = false;
      _showAlert('you can\'t have more than 8 members');
      return;
    }
    final response = await addMemberUseCase.call(_createInputParams(phoneNumber));
    response.fold((l) => onActionDone(failure: l), (r) => onActionDone(result: r));
  }

  InputGroupMemberUsecase _createInputParams(String phoneNumber) =>
      InputGroupMemberUsecase(groupId: _groupId!, phoneNumber: phoneNumber);

  void _actionRemove(String phoneNumber) async {
    final response = await groupRemoveMemberUseCase.call(_createInputParams(phoneNumber));
    response.fold((l) => onActionDone(failure: l), (r) => onActionDone(result: r));
  }

  void onActionDone({IFailure? failure, GroupEntity? result}) {
    _setBusy(false);
    if (failure == null) {
      updateWith(result!);
      // loadData();
    } else {
      showAlert(failure.toString());
    }
    //TODO: fetch group detail
  }

  void showAlert(String msg, {String? title}) {
    DialogService.simpleAlert(title: title ?? "Alert", body: msg);
  }

  void actionRemoveMember(String phoneNumber) async {
    _setBusy(true);
    try {
      final result =
          await groupRemoveMemberUseCase.call(InputGroupMemberUsecase(groupId: _groupId!, phoneNumber: phoneNumber));
      _setBusy(false);
      result.fold((l) => _showAlert(l.toString()), (r) {
        loadData();
        DialogService.showToast(msg: "User removed $phoneNumber");
      });
    } catch (e) {
      _setBusy(false);
      _showAlert(e.toString());
    }
  }

  void _setBusy(bool st) {
    if (st) {
      DialogService.showLoading();
    } else {
      DialogService.closeLoading();
      // Modular.to.pop();
    }
  }

  void _showAlert(String msg) {
    DialogService.simpleAlert(title: "Alert", body: msg);
  }

  void dispose() {
    _attachStreamBinder.dispose();
    _fetchGroupStreamBinder.dispose();
    _addMemberStreamBinder.dispose();
  }

  GroupEntity? getLoadedValue() {
    return _fetchGroupStreamBinder.loadedValue;
  }

  void updateWith(GroupEntity groupEntity) {
    _fetchGroupStreamBinder.addLoadedValue(groupEntity);
    fetchGroupListBloc.updateWith(groupEntity);
  }
}
