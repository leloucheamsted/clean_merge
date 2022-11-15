import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tello_social_app/modules/common/constants/layout_constants.dart';
import 'package:tello_social_app/modules/common/presentation/upload_avatar/upload_avatar_widget.dart';
import 'package:tello_social_app/modules/common/widget/custom_app_bar.dart';
import 'package:tello_social_app/modules/core/services/dialog_service.dart';
import 'package:tello_social_app/modules/user/presentation/blocs/user_profile_bloc.dart';
import '../../../common/constants/constants.dart';
import '../../../common/widgets.dart';
import '../../../core/presentation/streambuilder_all.dart';
import '../../domain/entities/app_user.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late UserProfileBloc bloc = Modular.get();

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
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(
        title: "Profile Settings",
        forceDrawer: false,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder_all<ActionState<AppUser?>>(
      stream: bloc.fetchUserDetailStreamBinder.outStream,
      onError: (context, error, {exception}) {
        return SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              // mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: Center(child: buildDefaultError(error, null))),
                // Spacer(),
                _buildActonBtn(context),
                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
        );
      },
      onSuccess: (_, data) {
        return _buildBody2(data!.data!);
      },
    );
  }

  Widget _buildBody2(AppUser appUser) {
    return Column(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              _buildAvatarUploadPart(avatarUrl: appUser.avatar),
              _buildPropertyItem(
                iconData: Icons.person,
                label: "Name",
                title: appUser.displayName ?? "",
                description: "Your display name",
                trailing: IconButton(
                  onPressed: bloc.setDisplayName,
                  icon: Icon(Icons.edit),
                ),
              ),
              _buildDivider(),
              _buildPropertyItem(
                iconData: Icons.phone,
                label: "Phone",
                title: appUser.phoneNumber,
                description: "Your phone number",
                trailing: IconButton(
                  onPressed: () => DialogService.copyToClipBoard(appUser.phoneNumber),
                  icon: Icon(Icons.copy),
                ),
                // description: "Your display name",
              ),
              // Spacer(),
              // _buildActonBtn(context),
              // SizedBox(height: MediaQuery.of(context).padding.bottom),
              // const SizedBox(height: LayoutConstants.spaceXL),
            ],
          ),
        ),
        Spacer(),
        _buildActonBtn(context),
        SizedBox(height: MediaQuery.of(context).padding.bottom),
        const SizedBox(height: LayoutConstants.spaceM),
      ],
    );
  }

  Widget _buildActonBtn(BuildContext context) {
    return SimpleButton(
      onTap: bloc.actionLogOut,
      content: "LOGOUT",
      // background: ColorPalette.blueStatutColor,
      background: Colors.blueGrey,
      iconPath: IconsName.delete,
      width: MediaQuery.of(context).size.width * .6,
    );
  }

  Widget _buildDivider() {
    return const SizedBox(height: LayoutConstants.spaceL);
  }

  Widget _buildPropertyItem({
    required IconData iconData,
    required String label,
    required String title,
    String? description,
    Widget? trailing,
  }) {
    return PropertyWidget(
      leading: Icon(iconData),
      label: label,
      title: title,
      description: description,
      trailing: trailing,
    );
  }

  Widget _buildAvatarUploadPart({String? avatarUrl}) {
    final double height = MediaQuery.of(context).size.height * .24;
    return Container(
      color: ColorPalette.telloBgColor,
      width: double.infinity,
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(LayoutConstants.paddingL),
        child: UploadAvatarWidget(
          // entityId: widget.groupId,
          uploadParams: {"type": "user"},
          initImageUrl: avatarUrl,
          size: height,
        ),
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
