import 'package:flutter/material.dart';
import 'package:tello_social_app/modules/chat/domain/entities/group.entity.dart';
import 'package:tello_social_app/modules/chat/domain/entities/group_member.entity.dart';
import 'package:tello_social_app/modules/chat/presentation/blocs/group_edit_bloc.dart';
import 'package:tello_social_app/modules/chat/presentation/ui/members/member_list_widget.dart';
import 'package:tello_social_app/modules/common/widget/custom_app_bar.dart';
import 'package:tello_social_app/modules/common/widgets.dart';
import 'package:tello_social_app/modules/core/presentation/list/grid_widget.dart';
import 'package:tello_social_app/modules/core/presentation/streambuilder_all.dart';

import '../../../common/constants/constants.dart';
import '../../../common/constants/layout_constants.dart';
import '../../../common/presentation/upload_avatar/upload_avatar_widget.dart';
import '../ui/members/member_grid_item.dart';

class GroupEditPage extends StatefulWidget {
  final String groupId;
  const GroupEditPage({
    Key? key,
    required this.groupId,
  }) : super(key: key);

  @override
  State<GroupEditPage> createState() => _GroupEditPageState();
}

class _GroupEditPageState extends State<GroupEditPage> {
  // late final Gro bloc = Modular.get();

  late GroupEditBloc bloc = GroupEditBloc(widget.groupId);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Edit Group',
        forceDrawer: false,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder_all<ActionState<GroupEntity>>(
      stream: bloc.outStream,
      onSuccess: (_, data) {
        return _buildBody2(data?.data);
      },
    );
  }

  Widget _buildBody2(GroupEntity? groupEntity) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: Scrollbar(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    _buildAvatarUploadPart(avatarUrl: groupEntity?.avatar),
                    const SizedBox(height: LayoutConstants.spaceL),
                    _buildNameField(groupEntity!.name),
                    const SizedBox(height: LayoutConstants.spaceXL),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Members"),
                        const SizedBox(height: LayoutConstants.spaceL),
                        _buildMemberList(groupEntity),
                      ],
                    ),
                    // if (groupEntity.isOwner) Spacer(),
                    // if (groupEntity.isOwner) _buildRemoveGroupBtn(),
                    if (groupEntity.isOwner) const SizedBox(height: LayoutConstants.spaceXL),
                  ],
                ),
              ),
            ),
          ),
          if (groupEntity.isOwner) _buildRemoveGroupBtn(),
          if (groupEntity.isOwner) SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildRemoveGroupBtn() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: LayoutConstants.paddingS),
      color: ColorPalette.telloBgColor,
      child: Center(
        child: SimpleButton(
          onTap: bloc.actionDeleteGroup,
          width: MediaQuery.of(context).size.width * .7,
          content: "DELETE GROUP",
          background: ColorPalette.redStatutColor,
          iconPath: IconsName.delete,
        ),
      ),
    );
  }

  Widget _buildNameField(String name) {
    return GestureDetector(
      onTap: bloc.actionRename,
      child: Container(
        height: LayoutConstants.textFieldHeight,
        width: MediaQuery.of(context).size.width * 0.7,
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(LayoutConstants.radiusS),
            border: Border.all(
              width: 1,
              color: ColorPalette.btnDisable,
            )),
        child: Padding(
          padding: const EdgeInsets.all(LayoutConstants.paddingS),
          child: Text(name),
        ),
      ),
    );
  }

  Widget _buildAvatarUploadPart({String? avatarUrl}) {
    return UploadAvatarWidget(
      // entityId: widget.groupId,
      uploadParams: {"id": widget.groupId, "type": "group"},
      initImageUrl: avatarUrl,
      onUploadFinish: bloc.onAvatarUploadFinish,
    );
  }

  Widget _buildMemberList(GroupEntity? groupEntity) {
    if (groupEntity == null || groupEntity.members.isEmpty) {
      /*
      final ContactListPageParams pageParams = ContactListPageParams(
      // members: memberList == null ? [] : memberList!.map((e) => e.phoneNumber.replaceAll(" ", "")).toList(),
      membersPhoneStream: outMembersPhoneNumberStream,
      onSelectContact: actionAddOrRemove,
    );
    Modular.to.pushNamed<ContactEntity>(AppRoute.contacts.path, arguments: pageParams);
      */
      return const SizedBox();
    }
    return GridWidget(
        itemCount: groupEntity.members.length,
        itemBuilder: (_, int index) => _buildGroupMemberItem(groupEntity.members[index], groupEntity.isOwner),
        crossAxisCount: 3,
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
        childAspectRatio: 0.8);
    MemberListWidget(
      items: groupEntity.members,
      // onMemberRemoveBtn: bloc.actionRemoveMember,
    );
  }

  Widget _buildGroupMemberItem(GroupMemberEntity entity, bool isOwner) {
    return MemberGridItem(
      entity: entity,
      canRemove: isOwner,
      onAction: () => bloc.actionDeleteMember(entity.phoneNumber),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
