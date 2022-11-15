import 'dart:io';

import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tello_social_app/modules/common/presentation/upload_avatar/select_upload_image.bloc.dart';
import 'package:tello_social_app/modules/common/widgets.dart';
import 'package:tello_social_app/modules/core/presentation/streambuilder_all.dart';

class UploadAvatarWidget extends StatefulWidget {
  // final String entityId;
  final String? initImageUrl;
  final Map<String, dynamic> uploadParams;
  final SelectUploadImageBloc? selectUploadImageBloc;
  final Function? onUploadFinish;
  final double size;
  const UploadAvatarWidget({
    Key? key,
    required this.uploadParams,
    this.selectUploadImageBloc,
    this.initImageUrl,
    this.size = 150,
    this.onUploadFinish,
  }) : super(key: key);

  @override
  State<UploadAvatarWidget> createState() => _UploadAState();
}

class _UploadAState extends State<UploadAvatarWidget> {
  // late final SelectUploadImageBloc bloc = Modular.get();
  late final SelectUploadImageBloc bloc = widget.selectUploadImageBloc ?? Modular.get();

  @override
  void initState() {
    bloc.setOnUploadFinishResponse(widget.onUploadFinish);
    bloc.addUploadParams(widget.uploadParams);
    if (widget.initImageUrl != null) {
      bloc.addDefaultPath(widget.initImageUrl!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  Widget _buildBody(BuildContext context) {
    return _buildTopPart(context);
  }

  /*void _doUploadAction() async {
    try {
      DialogService.showLoading();
      final response = await bloc.upload(
        params: widget.uploadParams,
      );

      DialogService.simpleAlert(title: "Done", body: response.toString());
    } catch (e) {
      DialogService.closeLoading();
      DialogService.simpleAlert(title: "Error", body: e.toString());
    }
  }*/

  Widget _buildProgressPart() {
    return StreamBuilder_all<int?>(
      stream: bloc.uploadProgressStream,
      onLoading: (context) => _buildProgressPart2(null),
      onSuccess: (_, data) {
        if (data == null) {
          return const SizedBox();
        }
        return _buildProgressPart2(data <= 1 ? null : data / 100);
      },
    );
  }

  Widget _buildProgressPart2(double? value) {
    return LinearProgressIndicator(
      value: value,
      backgroundColor: Colors.grey.shade400,
    );
  }

  Widget _buildTopPart(BuildContext context) {
    Widget w = Container(
      alignment: Alignment.center,
      height: 100,
      color: Colors.grey,
      child: _buildAvatarContent(),
    );
    w = CircleContainer(
      width: widget.size,
      height: widget.size,
      color: Colors.grey,
      borderColor: Colors.green,
      borderWidth: 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(300.0),
        child: _buildAvatarContent(),
      ),
      // image: ,
    );
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        w,
        CircleButton(
            color: Colors.green,
            onPressed: _onSelectImportMethod,
            child: Icon(
              Icons.photo_camera,
              size: 30,
            )),
      ],
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _onSelectImportMethod();
      },
      child: w,
    );
  }

  Widget _buildAvatarContent() {
    return StreamBuilder_all<dartz.Either<String, File>?>(
      stream: bloc.contentStream,
      onLoading: (context) => Text("loading"),
      onSuccess: (_, data) {
        if (data == null) {
          return const Icon(
            Icons.add_a_photo,
            size: 85,
          );
        }

        return data.fold<Widget>((l) => Image.network(l), (r) => Image.file(r));
        // return data.startsWith("http") ? Image.network(data) : Image.file(File(data));
        // return data;
        // return Image.file(data);
        // return FileImage(data);
      },
    );
  }

  void _onSelectImportMethod() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            bottom: true,
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.image),
                    title: Text("gallery"),
                    onTap: () {
                      Navigator.of(context).pop();
                      bloc.chooseImage.add(true);
                    }),
                ListTile(
                  leading: Icon(Icons.camera),
                  title: Text("camera"),
                  onTap: () {
                    Navigator.of(context).pop();
                    bloc.chooseImage.add(false);
                  },
                ),
              ],
            ),
          );
        });
  }
}
