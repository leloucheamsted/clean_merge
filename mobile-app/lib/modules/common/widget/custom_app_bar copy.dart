import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/constants.dart';
import '../constants/layout_constants.dart';

// ignore: camel_case_types
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onTap; //called function to navigate settings page
  final bool isCanBack; // to know if use can back or not
  final VoidCallback? backPrevious; //  event called when the return button is pressed
  final double height;
  final String? title;
  final Widget? titleWidget;
  final bool? isMessage; // to know if we have incoming message
  final bool? isGroupPage; // Knowing a are in a group page
  final VoidCallback? groupIconEvent; // call event when group button is clicked
  const CustomAppBar({
    Key? key,
    required this.onTap,
    required this.isCanBack,
    this.backPrevious,
    required this.height,
    this.isMessage,
    this.isGroupPage,
    this.groupIconEvent,
    this.title,
    this.titleWidget,
  }) : super(key: key);

  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorPalette.statutBarColor,
      height: height,
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: LayoutConstants.paddingS, vertical: LayoutConstants.paddingS),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              child: isGroupPage == true
                  ? // if isGroupPage==true is group Page show group button
                  Container(
                      height: LayoutConstants.iconBtnSize,
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: groupIconEvent,
                        child: Container(
                            height: LayoutConstants.iconBtnSize,
                            width: LayoutConstants.iconBtnSize,
                            decoration: BoxDecoration(
                              color: ColorPalette.greenStatutColor,
                              borderRadius: BorderRadius.circular(LayoutConstants.radiusM),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2 * LayoutConstants.paddingMin),
                              child: SvgPicture.asset(IconsName.groupIcon),
                            )),
                      ),
                    )
                  : isGroupPage == false
                      ? // else if is false show back button  to back previous Page
                      InkWell(
                          onTap: backPrevious,
                          child: Row(
                            children: [
                              SvgPicture.asset(IconsName.arrowLeft),
                              const SizedBox(
                                width: LayoutConstants.spaceM,
                              ),
                              const Text(
                                'Back',
                                style: TextStyle(
                                  fontFamily: Fonts.semiBold,
                                  fontSize: FontsSize.normalText,
                                  color: ColorPalette.greenStatutColor,
                                ),
                              ),
                            ],
                          ),
                        )
                      : // else if is null not show anything
                      const SizedBox(
                          width: 3 * LayoutConstants.spaceXL,
                        ),
            ),
            SizedBox(width: 10),

            /// App BAR TITLE TEXT
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(LayoutConstants.paddingZero, LayoutConstants.paddingZero,
                    LayoutConstants.paddingL, LayoutConstants.paddingZero),
                child: titleWidget != null
                    ? titleWidget
                    : Text(
                        title!,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: ColorPalette.colorText, fontFamily: Fonts.arialRegular, fontSize: FontsSize.title),
                      ),
              ),
            ),

            /// settings button to go  settings
            Container(
                height: LayoutConstants.iconBtnSize,
                alignment: Alignment.centerRight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    /// if we have message
                    /// _________________________ isMessage==true so show message button
                    SizedBox(
                      child: isMessage == false
                          ? InkWell(
                              onTap: onTap,
                              child: SvgPicture.asset(IconsName.message),
                            )
                          : null,
                    ),
                    const SizedBox(
                      width: LayoutConstants.spaceM,
                    ),
                    InkWell(
                      onTap: onTap,
                      child: SvgPicture.asset(IconsName.parameterBold),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
