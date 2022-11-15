import 'dart:io';

abstract class IImagePickerProvider {
  Future<File?> getImageFromGallery({
    double? maxWidth,
    double? maxHeight,
    double ratioX = 1,
    double ratioY = 1,
    bool flagCrop = true,
  });
  Future<File?> getImageFromCamera({
    double? maxWidth,
    double? maxHeight,
    double ratioX = 1,
    double ratioY = 1,
    bool flagCrop = true,
  });
}
