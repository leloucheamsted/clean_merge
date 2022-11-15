import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tello_social_app/modules/chat/domain/entities/group_message.entity.dart';
import 'package:tello_social_app/modules/chat/domain/usecases/message_list.usecase.dart';
import 'package:tello_social_app/modules/common/widget/no_items_widget.dart';
import 'package:tello_social_app/modules/common/widget/reload_btn.dart';
import 'package:tello_social_app/modules/core/presentation/either_stream_binder.dart';
import 'package:tello_social_app/modules/core/presentation/streambuilder_all.dart';

import '../ui/message_list/message_list_widget.dart';

class GroupMessagesPage extends StatefulWidget {
  final String groupId;
  const GroupMessagesPage({
    Key? key,
    required this.groupId,
  }) : super(key: key);

  @override
  State<GroupMessagesPage> createState() => _GroupMessagesPageState();
}

class _GroupMessagesPageState extends State<GroupMessagesPage> {
  late final streamBinder = EitherStreamBinder<List<GroupMessageEntity>>();

  late final MessageListUseCase useCase = Modular.get();

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  void _loadData() {
    streamBinder.callUseCase(
        () => useCase.call(
              MessageListParams(groupId: widget.groupId),
            ),
        forceLoading: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MessageList"),
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
    return StreamBuilder_all<ActionState<List<GroupMessageEntity>>>(
      stream: streamBinder.outStream,
      onSuccess: (_, data) {
        if (data == null || data.data == null) {
          return const NoItemsWidget(); //TODO: empty items common widget
        }
        return MessageListWidget(items: data.data!);
      },
    );
  }

  @override
  void dispose() {
    streamBinder.dispose();
    super.dispose();
  }
}
