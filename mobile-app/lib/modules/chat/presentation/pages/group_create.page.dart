import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tello_social_app/modules/chat/presentation/blocs/create_group.bloc.dart';
import 'package:tello_social_app/modules/common/widgets.dart';

import '../../../common/constants/constants.dart';
import '../../../common/constants/layout_constants.dart';
import '../../../common/presentation/upload_avatar/select_upload_image.bloc.dart';
import '../../../common/presentation/upload_avatar/upload_avatar_widget.dart';

class GroupCreatePage extends StatefulWidget {
  const GroupCreatePage({Key? key}) : super(key: key);

  @override
  State<GroupCreatePage> createState() => _GroupCreatePageState();
}

class _GroupCreatePageState extends State<GroupCreatePage> {
  late final CreateGroupBloc bloc = Modular.get();

  late final SelectUploadImageBloc selectUploadImageBloc = Modular.get();

  @override
  void initState() {
    selectUploadImageBloc.setAutoStart(false);
    bloc.setAvatarPathGetter(selectUploadImageBloc.getSelectedFilePath);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create group"),
      ),
      body: _buildBody(),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  Widget __buildBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SimpleButton(
        content: "Create",
        onTap: bloc.action,
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(LayoutConstants.paddingM),
      child: Column(
        children: [
          _buildAvatarUploadPart(),
          const SizedBox(height: LayoutConstants.spaceL),
          _buildNameField(),
          const SizedBox(height: LayoutConstants.spaceXL),
          Spacer(),
          _buildActionBtn(),
          const SizedBox(height: LayoutConstants.spaceXL),
        ],
      ),
    );
  }

  Widget _buildActionBtn() {
    return SimpleButton(
      onTap: bloc.action,
      content: "CREATE GROUP",
      // background: ColorPalette.redStatutColor,
      iconPath: IconsName.saveIcon,
    );
  }

  Widget _buildNameField() {
    return GestureDetector(
      onTap: bloc.setName,
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
          child: StreamBuilder<String>(
              stream: bloc.titleStream,
              builder: (context, snapshot) {
                return Text(snapshot.data ?? "");
              }),
        ),
      ),
    );
  }

  Widget _buildAvatarUploadPart({String? avatarUrl}) {
    return Padding(
      padding: const EdgeInsets.all(LayoutConstants.paddingL),
      child: UploadAvatarWidget(
        // entityId: widget.groupId,
        uploadParams: {},
        selectUploadImageBloc: selectUploadImageBloc,
        initImageUrl: avatarUrl,
      ),
    );
  }
}
