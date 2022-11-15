import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tello_social_app/modules/chat/domain/entities/group.entity.dart';
import 'package:tello_social_app/modules/chat/domain/usecases/group_set_active.usecase.dart';
import 'package:tello_social_app/modules/chat/presentation/blocs/fetch_grop_list_bloc.dart';
import 'package:tello_social_app/modules/common/constants/constants.dart';
import 'package:tello_social_app/modules/common/constants/layout_constants.dart';
import 'package:tello_social_app/modules/common/widgets.dart';
import 'package:tello_social_app/modules/core/presentation/streambuilder_all.dart';
import 'package:tello_social_app/routes/app_routes.enum.dart';

import '../../../../core/presentation/list/list_widget.dart';
import 'group_list_item.dart';
import 'group_list_widget.dart';

class GroupListDrawer extends StatefulWidget {
  const GroupListDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<GroupListDrawer> createState() => _GroupListDrawerState();
}

class _GroupListDrawerState extends State<GroupListDrawer> {
  late final FetchGroupListBloc bloc = Modular.get();

  bool isFetched = false;
  @override
  void initState() {
    if (!isFetched) {
      // _loadData();
      isFetched = true;
    }
    super.initState();
  }

  void _loadData() {
    bloc.loadData();
  }

  void onAddAction() {
    Modular.to.pushNamed(AppRoute.groupCreate.path);
  }

  Widget _buildAddBtn(bool flagListEmpty) {
    return SimpleButton(
      onTap: onAddAction,
      content: "${!flagListEmpty ? 'ADD' : 'CREATE'} GROUP",
      iconPath: IconsName.addGroups,
      width: MediaQuery.of(context).size.width * .5,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        if (data == null || data.data == null) {
          return const NoItemsWidget(); //TODO: empty items common widget
        }
        return _buildListBody(data.data!);
        return GroupListWidget(
          items: data.data!,
          onItemDeletePressed: (int index) => bloc.actionRemove(
            data.data![index].id,
          ),
        );
      },
    );
  }

  Widget _buildListBody(List<GroupEntity> items) {
    return Column(
      children: [
        Expanded(
            child: items.isEmpty
                ? Center(child: Text("Empty List"))
                : ListWidget(
                    itemCount: items.length, itemBuilder: (context, int id) => _itemBuilder(context, items[id]))),
        const SizedBox(height: LayoutConstants.spaceL),
        _buildAddBtn(items.isEmpty),
        const SizedBox(height: LayoutConstants.spaceXL),
      ],
    );
  }

  Widget _itemBuilder(BuildContext context, GroupEntity item) {
    return GestureDetector(
      onTap: () => _actionOpenGroup(item.id),
      child: GroupListItem(
        entity: item,
        onSetActivePressed: () => bloc.actionSetActiveGroup(item),
        onItemDeletePressed: () => bloc.actionRemove(item.id),
      ),
    );
  }

  @override
  void dispose() {
    // bloc.dispose();
    super.dispose();
  }

  _actionOpenGroup(String id) {
    Scaffold.of(context).closeDrawer();
    Modular.to.pushNamed(AppRoute.groupDetail.withIdParam(id));
  }
}
