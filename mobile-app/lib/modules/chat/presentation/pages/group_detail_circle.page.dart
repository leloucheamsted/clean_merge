import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tello_social_app/modules/chat/domain/entities/group.entity.dart';
import 'package:tello_social_app/modules/chat/presentation/blocs/group_detail_bloc.dart';
import 'package:tello_social_app/modules/chat/presentation/ui/group_drawer.dart';
import 'package:tello_social_app/modules/chat/presentation/ui/group_history_bottombar.dart';
import 'package:tello_social_app/modules/common/constants/constants.dart';
import 'package:tello_social_app/modules/common/constants/layout_constants.dart';
import 'package:tello_social_app/modules/common/widget/custom_app_bar.dart';
import 'package:tello_social_app/modules/common/widgets.dart';
import 'package:tello_social_app/modules/core/presentation/streambuilder_all.dart';
import 'package:tello_social_app/modules/ptt/presentation/blocs/ptt_bloc.dart';
import 'package:tello_social_app/routes/app_routes.enum.dart';

import '../ui/circle_menu/group_circle_nav_widget.dart';
import '../ui/ptt_center_circle.dart';

// TODO: put avatar of group top left
class GroupDetailCirclePage extends StatefulWidget {
  final String groupId;
  const GroupDetailCirclePage({
    Key? key,
    required this.groupId,
  }) : super(key: key);

  @override
  State<GroupDetailCirclePage> createState() => _GroupDetailCirclePageState();
}

class _GroupDetailCirclePageState extends State<GroupDetailCirclePage> {
  late final GroupDetailBloc bloc = Modular.get();
  late final PttBloc pttBloc = Modular.get();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late final StreamSubscription subs;

  @override
  void initState() {
    // pttBloc.connect();
    pttBloc.setMembersStream(bloc.outMemberStream);
    bloc.outMemberStream.listen((event) {});
    subs = bloc.outStream.listen((event) {
      if (event.status == ActionStateStatus.COMPLETED) {
        subs.cancel();
        pttBloc.connect();
      }
    });
    bloc.setGroupId(widget.groupId);
    _loadData();
    super.initState();
  }

  void _loadData() {
    bloc.loadData();
  }

  void _onAddAction() {
    bloc.actionAddContact();
    // bloc.actionAddOrRemove(contactEntity)
  }

  void _onAttach(String phoneNumber, bool flag) {
    bloc.actionAttach(phoneNumber, flag);
  }

  void _onTestBtn() {
    Modular.to.pushNamed(AppRoute.pttTest.path);
    // Modular.to.pushNamed(AppRoute.test.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ColorPalette.backgroundBodyColor,
      drawerEnableOpenDragGesture: false,
      drawer: const GroupDrawer(),
      // appBar: _buildAppBar(),
      appBar: CustomAppBar(titleWidget: _buildTitle(), actions: [
        IconButton(
          onPressed: _onTestBtn,
          icon: Icon(Icons.call),
        ),
      ]),
      body: _buildBody(context),
    );
  }

  Widget _buildTitle() {
    return StreamBuilder_all<ActionState<GroupEntity>>(
        stream: bloc.outStream,
        onInitial: (_) => _buildDefaultTitle(),
        onLoading: (_) => _buildDefaultTitle(),
        onError: (context, error, {exception}) => _buildDefaultTitle(),
        onSuccess: (_, data) {
          if (data == null || data.data == null) {
            return _buildDefaultTitle();
          }
          return _buildPageTitle(data.data!.name);
        });
  }

  Widget _buildDefaultTitle() {
    return _buildPageTitle("#${widget.groupId}");
  }

  Widget _buildPageTitle(String str) {
    return Text(
      str,
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(color: ColorPalette.colorText, fontFamily: Fonts.arialRegular, fontSize: FontsSize.title),
    );
  }

  void _onEditPressed() {
    // Modular.to.pushNamed(AppRoute.groupEdit.path, arguments: widget.groupId);
    Modular.to.pushNamed(AppRoute.groupEdit.withIdParam(widget.groupId));
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder_all<ActionState<GroupEntity>>(
      stream: bloc.outStream,
      onSuccess: (_, data) {
        return _buildMemberList(data?.data);
      },
    );
  }

  Widget _buildMemberList(GroupEntity? groupEntity) {
    return Column(
      children: [
        const SizedBox(height: LayoutConstants.paddingL),
        if (groupEntity != null && groupEntity.isOwner)
          Row(
            // mainAxisAlignment: MainAxisAlignment.end,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: LayoutConstants.paddingM),
              ImgLogoWidget(
                imgSrc: groupEntity.avatar,
                borderColor: Colors.green,
                borderWidth: 4,
              ),
              Spacer(),
              SimpleButton(
                onTap: _onEditPressed,
                // content: "",
                width: kMinInteractiveDimension,
                iconPath: IconsName.editIcon,
              ),
              const SizedBox(width: LayoutConstants.paddingM)
            ],
          ),
        Expanded(
          child: GroupCircleNavWidget(
            onAddAction: _onAddAction,
            onDragDropped: _onAttach,
            activeColor: Colors.blue,
            members: groupEntity!.members,
            attachedMembers: groupEntity.attachedMembers,
            isOwner: groupEntity.isOwner,
            centerWidget: _buildCenter(),
          ),
        ),
        const GroupHistoryBottomBar(),
        SizedBox(height: LayoutConstants.paddingL),
      ],
    );
    /*return groupEntity == null || groupEntity.members.isEmpty
        ? const SizedBox()
        : MemberListWidget(
            items: groupEntity.members,
            onMemberRemoveBtn: bloc.actionRemoveMember,
          );*/
  }

  Widget _buildCenter() {
    return PttCenterCircle(
      pttBloc: pttBloc,
    );
  }

  @override
  void dispose() {
    subs.cancel();
    bloc.dispose();
    pttBloc.dispose();
    super.dispose();
  }
}
