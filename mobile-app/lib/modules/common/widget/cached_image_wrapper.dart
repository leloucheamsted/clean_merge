import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

bool _validateUrl(String url) {
  return url.startsWith("http");
}

class CachedImageWrapper extends StatelessWidget {
  final String imageUrl;
  final BoxFit? fit;
  final PlaceholderWidgetBuilder? placeholder;
  final LoadingErrorWidgetBuilder? errorWidget;
  final String debugKey;
  const CachedImageWrapper({
    super.key,
    required this.imageUrl,
    required this.debugKey,
    this.fit,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (!_validateUrl(imageUrl)) {
      log("$debugKey #incorrectImageUrl $imageUrl");
    }
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.contain,
      placeholder: placeholder,
      errorWidget: errorWidget,
    );
  }
}

class CachedNetworkImageProviderWrapper extends CachedNetworkImageProvider {
  final String? debugKey;
  CachedNetworkImageProviderWrapper(
    super.url, {
    this.debugKey,
  });

  @override
  ImageStreamCompleter loadBuffer(CachedNetworkImageProvider key, DecoderBufferCallback decode) {
    if (!_validateUrl(url)) {
      log("$debugKey #incorrectImageUrl.provider $url");
    }
    return super.loadBuffer(key, decode);
  }
}
