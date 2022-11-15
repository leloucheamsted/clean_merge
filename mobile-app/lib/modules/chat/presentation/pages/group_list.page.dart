import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tello_social_app/modules/chat/domain/entities/group.entity.dart';
import 'package:tello_social_app/modules/chat/presentation/blocs/fetch_grop_list_bloc.dart';
import 'package:tello_social_app/modules/common/widget/no_items_widget.dart';
import 'package:tello_social_app/modules/common/widget/reload_btn.dart';
import 'package:tello_social_app/modules/core/presentation/streambuilder_all.dart';
import 'package:tello_social_app/routes/app_routes.enum.dart';

import '../blocs/remove_group.bloc.dart';
import '../ui/group_list/group_list_widget.dart';

class GroupListPage extends StatefulWidget {
  const GroupListPage({
    Key? key,
  }) : super(key: key);

  @override
  State<GroupListPage> createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  late final FetchGroupListBloc bloc = Modular.get();

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  void _loadData() {
    bloc.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Modular.to.pushNamed(AppRoute.groupCreate.path),
      ),
      appBar: AppBar(
        title: const Text("GroupList"),
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
    return StreamBuilder_all<ActionState<List<GroupEntity>>>(
      stream: bloc.outStream,
      onSuccess: (_, data) {
        if (data == null || data.data == null || data.data!.isEmpty) {
          return const NoItemsWidget(); //TODO: empty items common widget
        }
        return GroupListWidget(
          items: data.data!,
          onItemDeletePressed: (int index) => bloc.actionRemove(
            data.data![index].id,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // bloc.dispose();
    super.dispose();
  }
}
