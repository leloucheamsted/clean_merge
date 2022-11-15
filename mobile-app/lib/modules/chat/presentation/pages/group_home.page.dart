import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tello_social_app/modules/chat/domain/entities/group.entity.dart';
import 'package:tello_social_app/modules/chat/presentation/blocs/group_detail_bloc.dart';
import 'package:tello_social_app/modules/chat/presentation/ui/group_drawer.dart';
import 'package:tello_social_app/modules/chat/presentation/ui/members/member_list_widget.dart';
import 'package:tello_social_app/modules/common/constants/layout_constants.dart';
import 'package:tello_social_app/modules/common/widget/buttons/simple_button.dart';
import 'package:tello_social_app/modules/common/widget/custom_app_bar.dart';
import 'package:tello_social_app/modules/common/widget/reload_btn.dart';
import 'package:tello_social_app/modules/core/presentation/streambuilder_all.dart';
import 'package:tello_social_app/routes/app_routes.enum.dart';

import '../../../common/constants/constants.dart';
import '../../../common/presentation/upload_avatar/upload_avatar_widget.dart';
import '../ui/circle_menu/group_circle_nav_widget.dart';

class GroupHomePage extends StatelessWidget {
  const GroupHomePage({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: GroupDrawer(),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Center(
            child: GroupCircleNavWidget(
              onAddAction: () {},
              onDragDropped: (_, __) {},
              members: [],
              attachedMembers: [],
              isOwner: true,
              activeColor: Colors.blue,
              centerWidget: _buildCustomCenterWidget(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: LayoutConstants.spaceXL),
            child: _buildActonBtn(context),
          ),
          // const SizedBox(height: LayoutConstants.spaceXL),
          // SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildCustomCenterWidget() {
    return SizedBox(
      height: 100,
      // width: 50,
      // color: AppTheme().colors.mainBackground,
      child: Image.asset('assets/images/tello_logo.png'),
    );
  }

  Widget _buildActonBtn(BuildContext context) {
    return SimpleButton(
      onTap: _onAction,
      content: "CREATE GROUP",
      // background: ColorPalette.blueStatutColor,
      background: Colors.blueGrey,
      iconPath: IconsName.delete,
      width: MediaQuery.of(context).size.width * .6,
    );
  }

  void _onAction() {
    Modular.to.pushNamed(AppRoute.groupCreate.path);
  }
}
