import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tello_social_app/routes/app_routes.enum.dart';

import '../constants/constants.dart';
import '../constants/layout_constants.dart';

// ignore: camel_case_types
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  // final VoidCallback onTap; //called function to navigate settings page
  // final bool isCanBack; // to know if use can back or not
  final VoidCallback? backPrevious; //  event called when the return button is pressed
  // final double height;
  final String? title;
  final Widget? titleWidget;
  final bool forceDrawer;
  final List<Widget>? actions;
  // final bool? isMessage; // to know if we have incoming message
  // final bool? isGroupPage; // Knowing a are in a group page
  final VoidCallback? groupIconEvent; // call event when group button is clicked
  const CustomAppBar({
    Key? key,
    // required this.onTap,
    // required this.isCanBack,
    this.backPrevious,
    this.actions,
    // required this.height,
    // this.isMessage,
    // this.isGroupPage,
    this.forceDrawer = true,
    this.groupIconEvent,
    this.title,
    this.titleWidget,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Widget _buildAppBar2(BuildContext context) {
    //TODO: refactor to navobserver cause last stack lazy updates
    final r = Modular.to.navigateHistory.last.name == AppRoute.userProfileCurrent.path;

    final List<Widget> list = <Widget>[
      if (!r)
        IconButton(
          onPressed: () => Modular.to.pushNamed(AppRoute.userProfileCurrent.path),
          icon: SvgPicture.asset(IconsName.parameterBold),
        )
    ];
    if (actions != null) {
      list.addAll(actions!);
    }
    // final bool canGoBack = Modular.to.canPop();
    final bool canGoBack = forceDrawer ? false : Modular.to.canPop();
    return AppBar(
      centerTitle: true,
      // backgroundColor: Colors.green.shade500,
      leading: _buildLeadingWidget(context, canGoBack),

      leadingWidth: canGoBack ? 200 : 100,
      elevation: 0,
      // shape: Border(bottom: BorderSide(color: Colors.green.shade300, width: 12)),
      actions: list,
      title: title != null
          ? Text(
              title!,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: ColorPalette.colorText, fontFamily: Fonts.arialRegular, fontSize: FontsSize.title),
            )
          : titleWidget,
    );
  }

  Widget _buildLeadingWidget(BuildContext context, bool canGoBack) {
    if (canGoBack) {
      return GestureDetector(
        onTap: Modular.to.pop,
        child: Row(
          children: [
            const SizedBox(width: LayoutConstants.spaceL),
            SvgPicture.asset(IconsName.arrowLeft),
            const SizedBox(width: LayoutConstants.spaceM),
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
      );
    }
    // context.rootAncestorStateOfType;
    return GestureDetector(
      onTap: Scaffold.of(context).openDrawer,
      child: Row(
        children: [
          const SizedBox(width: LayoutConstants.spaceL),
          Container(
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildAppBar2(context);
  }
}
