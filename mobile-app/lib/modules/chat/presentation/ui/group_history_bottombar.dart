import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/constants/constants.dart';
import '../../../common/constants/layout_constants.dart';

//TODO: need to refactor clean
class GroupHistoryBottomBar extends StatelessWidget {
  const GroupHistoryBottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 68,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: LayoutConstants.paddingM),
          child: Row(
            children: [
              //____________Play button
              InkWell(
                onTap: () {},
                child: Container(
                  alignment: Alignment.center,
                  height: LayoutConstants.iconBtnSize,
                  width: LayoutConstants.iconBtnSize,
                  decoration: BoxDecoration(
                    color: ColorPalette.btnDisable,
                    borderRadius: BorderRadius.circular(LayoutConstants.iconBtnRadius),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(LayoutConstants.paddingS / 2, LayoutConstants.paddingZero,
                        LayoutConstants.paddingZero, LayoutConstants.paddingZero),
                    child: SvgPicture.asset(
                      IconsName.playIcon,
                      height: 28,
                      width: 21,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                width: LayoutConstants.spaceXL,
              ),
              //______________Refresh button
              InkWell(
                onTap: () {},
                child: SvgPicture.asset(IconsName.refreshIcon),
              ),
              const SizedBox(
                width: LayoutConstants.spaceXL,
              ),
              //____________Control audio message
              Container(
                  alignment: Alignment.centerRight,
                  child: const Text(
                    'No audio messages',
                    style:
                        TextStyle(fontFamily: Fonts.bold, fontSize: FontsSize.smallText, color: ColorPalette.colorText),
                  )),
            ],
          ),
        ));
  }
}
