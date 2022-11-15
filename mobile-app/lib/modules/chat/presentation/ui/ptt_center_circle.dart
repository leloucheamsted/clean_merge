import 'package:flutter/material.dart';
import 'package:tello_social_app/modules/common/constants/constants.dart';
import 'package:tello_social_app/modules/common/widgets.dart';
import 'package:tello_social_app/modules/ptt/infra/services/ptt_soup/enitity/ptt_session_status.enum.dart';
import 'package:tello_social_app/modules/ptt/presentation/blocs/ptt_bloc.dart';

import 'members/member_avatar_circle.dart';

class PttCenterCircle extends StatelessWidget {
  // final VoidCallback onPressStart;
  // final VoidCallback onPressStop;
  final PttBloc pttBloc;
  const PttCenterCircle({
    Key? key,
    // required this.onPressStart,
    // required this.onPressStop,
    required this.pttBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PttSessionStatus>(
        stream: pttBloc.outPttSessionStatusStream,
        builder: (context, snapshot) {
          final PttSessionStatus pttSessionStatus = snapshot.data ?? PttSessionStatus.disconnected;
          return IgnorePointer(
            ignoring:
                pttSessionStatus == PttSessionStatus.disconnected || pttSessionStatus == PttSessionStatus.receiving,
            child: Listener(
              // onPointerDown: (_) => onPressStart(),
              // onPointerUp: (_) => onPressStop(),
              onPointerDown: (_) => pttBloc.actionTalk(true),
              onPointerUp: (_) => pttBloc.actionTalk(false),

              // onTapDown: (_) => onPressStart(),
              // onTapUp: (_) => onPressStop,
              // onTapCancel: () => onPressStop,
              child: Container(
                width: 150,
                height: 150,
                // padding: EdgeInsets.all(12),

                decoration: BoxDecoration(
                  // border: borderColor == null ? null : Border.all(color: borderColor!, width: borderWidth ?? 1),
                  // color: Colors.grey.shade200,
                  color: _getColorByStatus(pttSessionStatus),
                  shape: BoxShape.circle,
                ),
                child: _buildBody(pttSessionStatus),
              ),
            ),
          );
        });
  }

  Color _getColorByStatus(PttSessionStatus st) {
    late final Color c;
    switch (st) {
      case PttSessionStatus.sending:
        c = ColorPalette.pttTransmitting;
        break;
      case PttSessionStatus.receiving:
        c = ColorPalette.pttReceiving;
        break;
      default:
        c = Colors.grey.shade200;
    }
    return c;
  }

  Widget _buildBody(PttSessionStatus st) {
    if (st == PttSessionStatus.receiving) {
      return MemberAvatarCircle(entity: pttBloc.producingMember!);
    }
    return Icon(
      Icons.mic,
      size: 82,
      color: st == PttSessionStatus.disconnected ? Colors.grey : Colors.green,
    );
  }
}
