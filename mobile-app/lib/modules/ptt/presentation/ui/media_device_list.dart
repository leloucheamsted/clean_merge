import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class MediaDeviceList extends StatelessWidget {
  final List<MediaDeviceInfo> list;
  const MediaDeviceList({
    Key? key,
    required this.list,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      primary: false,
      itemBuilder: ((context, index) {
        return _buildItem(list[index]);
      }),
    );
  }

  Widget _buildItem(MediaDeviceInfo info) {
    return Text(info.label);
  }
}
