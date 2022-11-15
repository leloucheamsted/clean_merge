import 'package:flutter/src/foundation/key.dart';
import 'package:tello_social_app/modules/common/widget/buttons/abstract_button.dart';

import '../../constants/constants.dart';

class SendButton extends AbstractButton {
  const SendButton({
    Key? key,
    required super.onTap,
    super.width,
    super.isEnabled,
  }) : super(
          key: key,
          content: "SEND",
          iconPath: IconsName.send,
          background: ColorPalette.greenStatutColor,
        );
}
