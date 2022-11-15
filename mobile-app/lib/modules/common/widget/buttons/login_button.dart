import 'package:flutter/src/foundation/key.dart';
import 'package:tello_social_app/modules/common/widget/buttons/abstract_button.dart';

import '../../constants/constants.dart';

class LoginButton extends AbstractButton {
  const LoginButton({
    Key? key,
    required super.onTap,
    super.width,
    super.isEnabled,
  }) : super(
          key: key,
          content: "LOGIN",
          iconPath: IconsName.login,
          background: ColorPalette.greenStatutColor,
        );
}
