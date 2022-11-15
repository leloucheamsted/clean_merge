import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tello_social_app/modules/chat/domain/entities/group.entity.dart';
import 'package:tello_social_app/modules/chat/presentation/blocs/group_detail_bloc.dart';
import 'package:tello_social_app/modules/chat/presentation/ui/members/member_list_widget.dart';
import 'package:tello_social_app/modules/common/widget/reload_btn.dart';
import 'package:tello_social_app/modules/core/presentation/streambuilder_all.dart';
import 'package:tello_social_app/routes/app_routes.enum.dart';

import '../../../common/presentation/upload_avatar/upload_avatar_widget.dart';

class GroupDetailPage extends StatefulWidget {
  final String groupId;
  const GroupDetailPage({
    Key? key,
    required this.groupId,
  }) : super(key: key);

  @override
  State<GroupDetailPage> createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends State<GroupDetailPage> {
  late final GroupDetailBloc bloc = Modular.get();

  @override
  void initState() {
    bloc.setGroupId(widget.groupId);
    _loadData();
    super.initState();
  }

  void _loadData() {
    bloc.loadData();
  }

  Widget _buildTitle() {
    return StreamBuilder_all<ActionState>(
        stream: bloc.outStream,
        onInitial: (_) => _buildDefaultTitle(),
        onLoading: (_) => _buildDefaultTitle(),
        onError: (context, error, {exception}) => _buildDefaultTitle(),
        onSuccess: (_, data) {
          if (data == null || data.data == null) {
            return _buildDefaultTitle();
          }
          return _buildPageTitle(data.data.displayName);
        });
  }

  Widget _buildDefaultTitle() {
    return _buildPageTitle("#${widget.groupId}");
  }

  Widget _buildPageTitle(String str) {
    return Text(str);
  }

  void _onTestBtn() {
    Modular.to.pushNamed(AppRoute.test.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildTitle(),
        actions: [
          ReloadBtn(
            onPressed: _loadData,
          ),
          IconButton(
            onPressed: _onTestBtn,
            icon: Icon(Icons.call),
          )
        ],
      ),
      floatingActionButton: _buildAddMemberBtn(),
      body: _buildBody(context),
    );
  }

  Widget _buildAddMemberBtn2() {
    return FloatingActionButton(onPressed: bloc.actionSelectContact, child: const Icon(Icons.add));
  }

  Widget _buildAddMemberBtn() {
    return StreamBuilder_all<ActionState>(
        stream: bloc.outStreamAddMember,
        onInitial: (_) => _buildAddMemberBtn2(),
        onError: (context, error, {exception}) => _buildAddMemberBtn2(),
        onSuccess: (_, data) {
          return _buildAddMemberBtn2();
        });
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
    return Column(
      children: [
        _buildAvatarUploadPart(avatarUrl: groupEntity?.avatar),
        Expanded(
          child: _buildMemberList(groupEntity),
        ),
      ],
    );
  }

  Widget _buildAvatarUploadPart({String? avatarUrl}) {
    return UploadAvatarWidget(
      // entityId: widget.groupId,
      uploadParams: {"id": widget.groupId, "type": "group"},
      initImageUrl: avatarUrl,
    );
  }

  Widget _buildMemberList(GroupEntity? groupEntity) {
    return groupEntity == null || groupEntity.members.isEmpty
        ? const SizedBox()
        : MemberListWidget(
            items: groupEntity.members,
            onMemberRemoveBtn: bloc.actionRemoveMember,
          );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
