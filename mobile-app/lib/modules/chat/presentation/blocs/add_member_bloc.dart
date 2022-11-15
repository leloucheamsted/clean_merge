import 'package:flutter_modular/flutter_modular.dart';
import 'package:tello_social_app/modules/chat/domain/entities/group.entity.dart';
import 'package:tello_social_app/modules/core/error/failure.dart';
import 'package:tello_social_app/modules/core/presentation/blocs/base_bloc.dart';

import '../../../contact/domain/entities/contact.entity.dart';
import '../../domain/entities/group_member.entity.dart';
import '../../domain/usecases/group_add_member.usecase.dart';
import '../../domain/usecases/group_remove_member.usecase.dart';
import '../../domain/usecases/input_group_member_usecase.dart';

class AddMemberBloc extends BaseBloc {
  late final List<GroupMemberEntity> _members = [];
  late final GroupEntity currentGroup;
  List<GroupMemberEntity> get memberList => currentGroup.members;
  // String get groupId => _groupId;
  late bool _isEditable = true;
  bool get isEditable => _isEditable;

  late final GroupAddMemberUseCase addMemberUseCase = Modular.get();
  late final GroupRemoveMemberUseCase groupRemoveMemberUseCase = Modular.get();
  void setGroup(GroupEntity groupEntity) {
    currentGroup = groupEntity;
  }

  // AddMemberBloc() {}
  bool isContactIsAGroupMember(ContactEntity contactEntity) =>
      memberList.any((element) => element.phoneNumber == contactEntity.phoneNumber);

  void actionAddOrRemove(ContactEntity contactEntity) {
    final bool contains = isContactIsAGroupMember(contactEntity);
    contains ? _actionRemove(contactEntity.phoneNumber) : _actionAdd(contactEntity.phoneNumber);
  }

  void _actionAdd(String phoneNumber) async {
    if (memberList.length == 8) {
      _isEditable = false;
      showAlert('you can\'t have more than 8 members');
      return;
    }
    final response = await addMemberUseCase.call(_createInputParams(phoneNumber));
    response.fold((l) => onActionDone(failure: l), (r) => onActionDone());
  }

  void onActionDone({IFailure? failure}) {
    setBusy(false);
    //TODO: fetch group detail
  }

  InputGroupMemberUsecase _createInputParams(String phoneNumber) =>
      InputGroupMemberUsecase(groupId: currentGroup.id, phoneNumber: phoneNumber);

  void _actionRemove(String phoneNumber) async {
    final response = await groupRemoveMemberUseCase.call(_createInputParams(phoneNumber));
    response.fold((l) => onActionDone(failure: l), (r) => onActionDone());
  }
}
