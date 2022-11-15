import 'package:flutter/material.dart';
import 'package:tello_social_app/modules/common/constants/layout_constants.dart';

class PropertyWidget extends StatelessWidget {
  final Widget leading;
  final String label;
  final String title;
  final String? description;
  final Widget? trailing;

  const PropertyWidget({
    Key? key,
    required this.leading,
    required this.label,
    required this.title,
    this.description,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // padding: const EdgeInsets.symmetric(horizontal: LayoutConstants.paddingM),
      padding: const EdgeInsets.all(LayoutConstants.paddingM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          leading,
          const SizedBox(width: LayoutConstants.spaceXL),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.caption,
                ),
                const SizedBox(height: LayoutConstants.spaceM),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: LayoutConstants.spaceM),
                if (description != null)
                  Text(
                    description!,
                    style: Theme.of(context).textTheme.caption,
                  ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
