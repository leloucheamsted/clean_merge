import 'package:flutter/material.dart';
import 'package:tello_social_app/modules/chat/domain/entities/group_member.entity.dart';
import 'package:tello_social_app/modules/chat/presentation/ui/circle_menu/connector_widget.dart';
import 'package:tello_social_app/modules/common/constants/constants.dart';
import 'package:tello_social_app/modules/common/constants/dummy_data.dart';
import 'package:tello_social_app/modules/common/widget/circle_container.dart';
import 'package:tello_social_app/modules/common/widget/img_logo_widget.dart';
import 'package:tello_social_app/modules/contact/domain/entities/contact.entity.dart';

import 'circle_menu_widget.dart';

class TelloCircleWidget extends StatefulWidget {
  final int total;
  final Color activeColor;
  final Curve connectorAnimationCurve;
  final bool isOwner;
  const TelloCircleWidget({
    Key? key,
    required this.total,
    required this.activeColor,
    this.isOwner = false,
    this.connectorAnimationCurve = Curves.elasticOut,
  }) : super(key: key);

  @override
  State<TelloCircleWidget> createState() => _TelloCircleWidgetState();
}

class _TelloCircleWidgetState extends State<TelloCircleWidget> {
  final int maxItems = 8;
  List<int> activeIndexes = [];
  @override
  Widget build(BuildContext context) {
    return CircleMenuWidget(
      startAngle: -15,
      colorInteractive: widget.activeColor,
      connectorAnimationCurve: widget.connectorAnimationCurve,
      itemCount: widget.total,
      fixedLength: 8,
      activeIndexes: activeIndexes,
      // items: circleMenuItemList,
      radius: MediaQuery.of(context).size.width * .8 * .5,
      itemBuilder: (BuildContext context, int index) {
        return _buildItem(index);
      },
      onDrop: _onDrop,
      dropTargetWidget: CircleContainer(color: widget.activeColor),
      connectorBuilder: (Color color) => ConnectorWidget(color: color), checkIsDraggable: (int id) => true,
    );
  }

  Widget _buildItem(int i) {
    final bool isDataItem = i < widget.total;
    return isDataItem ? _buildDataItem(i) : _buildNoDataItem();
  }

  Widget _buildNoDataItem() {
    return widget.isOwner
        ? const Icon(
            Icons.add_circle,
            color: Colors.grey,
          )
        : const CircleContainer(color: Colors.grey);
  }

  ContactEntity getEntity(int i) => DummyData.appContacts[i];
  Widget _buildDataItem(int i) {
    final entity = getEntity(6);
    return ImgLogoWidget(
      imgSrc: entity.avatar,
      borderColor: ColorPalette.greenStatutColor,
      borderWidth: 0,
    );
    return Text(
      i.toString(),
      style: TextStyle(color: Colors.grey.shade700, fontSize: 22, fontWeight: FontWeight.bold),
    );
  }

  void _onDrop(int id) {
    if (activeIndexes.contains(id)) {
      activeIndexes.remove(id);
    } else {
      activeIndexes.add(id);
    }
    setState(() {});
  }
}
