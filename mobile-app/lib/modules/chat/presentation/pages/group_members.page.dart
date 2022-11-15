import 'package:flutter/material.dart';
import 'package:tello_social_app/modules/chat/domain/entities/group_member.entity.dart';
import 'package:tello_social_app/modules/chat/presentation/ui/members/member_list_widget.dart';
import 'package:tello_social_app/modules/common/widget/no_items_widget.dart';
import 'package:tello_social_app/modules/common/widget/reload_btn.dart';
import 'package:tello_social_app/modules/core/presentation/either_stream_binder.dart';
import 'package:tello_social_app/modules/core/presentation/streambuilder_all.dart';

class GroupMembersPage extends StatefulWidget {
  final String groupId;
  const GroupMembersPage({
    Key? key,
    required this.groupId,
  }) : super(key: key);

  @override
  State<GroupMembersPage> createState() => _GroupMembersPageState();
}

class _GroupMembersPageState extends State<GroupMembersPage> {
  late final streamBinder = EitherStreamBinder<List<GroupMemberEntity>>();

  // late final MessageListUseCase useCase = Modular.get();

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  void _loadData() {
    /*streamBinder.callUseCase(
        () => useCase.call(
              MessageListParams(groupId: widget.groupId),
            ),
        flagLoading: true);*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Group Members"),
        actions: [
          ReloadBtn(
            onPressed: _loadData,
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder_all<ActionState<List<GroupMemberEntity>>>(
      stream: streamBinder.outStream,
      onSuccess: (_, data) {
        if (data == null || data.data == null) {
          return const NoItemsWidget(); //TODO: empty items common widget
        }
        return MemberListWidget(items: data.data!);
      },
    );
  }

  @override
  void dispose() {
    streamBinder.dispose();
    super.dispose();
  }
}
