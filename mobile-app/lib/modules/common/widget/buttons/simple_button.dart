import 'package:flutter/semantics.dart';
import 'package:tello_social_app/modules/common/widget/buttons/abstract_button.dart';

import '../../constants/constants.dart';

class SimpleButton extends AbstractButton {
  const SimpleButton({
    Key? key,
    required super.onTap,
    super.content,
    super.width,
    super.isEnabled,
    super.background = ColorPalette.greenStatutColor,
    super.iconPath,
  }) : super(
          key: key,
        );
}
