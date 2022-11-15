import 'package:flutter/material.dart';
import 'package:tello_social_app/modules/common/widgets.dart';

import 'cached_image_wrapper.dart';

class ImgLogoWidget extends StatelessWidget {
  final String? imgSrc;
  final double? width;
  final double? height;
  final double borderWidth;
  final Color borderColor;
  const ImgLogoWidget({
    Key? key,
    this.imgSrc,
    this.width = 80,
    this.height = 80,
    this.borderWidth = 1,
    this.borderColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleContainer(
      width: height,
      height: height,
      color: Colors.grey.shade300,
      image: _buildImg(),
      borderColor: borderColor,
      borderWidth: borderWidth,
      child: imgSrc != null
          ? null
          : const Icon(
              Icons.photo,
              color: Colors.grey,
            ),
    );
  }

  DecorationImage? _buildImg() {
    if (imgSrc == null) {
      return null;
    }
    return DecorationImage(
      fit: BoxFit.contain,
      image: CachedNetworkImageProviderWrapper(imgSrc!),
      // ? Image(width: 80,height: 80,image: SvgImageProvider(logoUrl!),)
    );
  }
}
