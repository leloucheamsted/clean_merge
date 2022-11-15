import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:tello_social_app/modules/core/services/interfaces/i_image_picker_provider.dart';
// import 'package:flutter_image_pick_crop/flutter_image_pick_crop.dart';

class ImagePickerProvider implements IImagePickerProvider {
  // final ImagePicker _picker = ImagePicker();

  // CancelableOperation<XFile?>? _pickFuture;
  // StreamSubscription? _pickStreamSubscription;
  Completer<File?>? _completer;
  bool _isChoosing = false;

  ImagePickerProvider();

  Future<File?> _pickeFromSource(ImageSource source) async {
    XFile? imagePicker = await ImagePicker().pickImage(source: source);
    return imagePicker == null ? null : File(imagePicker.path);
    _isChoosing = true;

    if (_completer != null) {
      if (!_completer!.isCompleted) {
        _completer!.complete(null);
      }
    } else {
      _completer = Completer();
    }

    log("_pickeFromSource $source");

    ImagePicker().pickImage(source: source).then((r) {
      log("pickImage.then $r");
      if (!_completer!.isCompleted) {
        _completer!.complete(r == null ? null : File(r.path));
      }
    }).catchError((err) {
      log("pickImage.catchError $err");
    }).whenComplete(() {
      log('pickImage.whenComplete');
    });

    return _completer!.future;

    // XFile? imagePicker = await _picker.pickImage(source: ImageSource.gallery);
    // return imagePicker == null ? null : File(imagePicker.path);
  }

  @override
  Future<File?> getImageFromGallery({
    double? maxWidth,
    double? maxHeight,
    double ratioX = 1,
    double ratioY = 1,
    bool flagCrop = true,
  }) async {
    // String result =await FlutterImagePickCrop.pickAndCropImage("fromGalleryCropImage");
    // File file = File(result);
    // return file;
    // File image = await ImagePicker.pickImage(source: ImageSource.gallery, maxWidth: maxWidth, maxHeight: maxHeight);
    File? image = await _pickeFromSource(ImageSource.gallery);
    if (image == null) {
      return null;
    }
    if (!flagCrop) {
      return image;
      // return image.path;
    }
    _log("imagePicked.applying crop");
    // return image;
    return _applyCrop(image, maxWidth, maxHeight, ratioX: ratioX, ratioY: ratioY);
  }

  void _log(String msg) {
    log("$runtimeType $msg");
  }

  @override
  Future<File?> getImageFromCamera({
    double? maxWidth,
    double? maxHeight,
    double ratioX = 1,
    double ratioY = 1,
    bool flagCrop = true,
  }) async {
    // String result =await FlutterImagePickCrop.pickAndCropImage("fromCameraCropImage");
    // File file = File(result);
    // return file;

    // File image = await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: maxWidth, maxHeight: maxHeight);
    File? image = await _pickeFromSource(ImageSource.camera);
    // return image;
    if (!flagCrop) {
      return image;
    }
    return _applyCrop(image, maxWidth, maxHeight, ratioX: ratioX, ratioY: ratioY);
  }

  Future<File?> _applyCrop(File? file, double? maxWidth, double? maxHeight,
      {double ratioX = 1, double ratioY = 1}) async {
    if (file == null) return null;
    CroppedFile? croppedFile = await ImageCropper().cropImage(
        maxWidth: maxWidth?.toInt(),
        maxHeight: maxHeight?.toInt(),
        sourcePath: file.path,
        aspectRatio: ratioX == 0 || ratioY == 0 ? null : CropAspectRatio(ratioX: ratioX, ratioY: ratioY),
        uiSettings: [
          IOSUiSettings(
            aspectRatioPickerButtonHidden: true,
            // aspectRatioLockEnabled: true,
            // resetAspectRatioEnabled: false,
            aspectRatioLockEnabled: false,
            resetAspectRatioEnabled: true,
            aspectRatioLockDimensionSwapEnabled: false,
            rotateButtonsHidden: false,
            rotateClockwiseButtonHidden: false,
            resetButtonHidden: true,
            doneButtonTitle: "done",
            cancelButtonTitle: "cancel",
            showActivitySheetOnDone: false,
          ),
          AndroidUiSettings(
            lockAspectRatio: true,
            // hideBottomControls: true,
            initAspectRatio: CropAspectRatioPreset.ratio3x2,
          )
        ]

        // ratioX: 3.0,
        // ratioY: 2.0,

        );
    _log("cropDone $croppedFile");
    return croppedFile == null ? null : File(croppedFile.path);
  }

  Future<File?> actionCrop(
    File file, {
    double? maxWidth,
    double? maxHeight,
    double ratioX = 1,
    double ratioY = 1,
    bool cropShapeRectOrCircle = true,
  }) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      // aspectRatio: null,
      cropStyle: cropShapeRectOrCircle ? CropStyle.rectangle : CropStyle.circle,
      aspectRatio: ratioX == 0 || ratioY == 0 ? null : CropAspectRatio(ratioX: ratioX, ratioY: ratioY),
      sourcePath: file.path,
      uiSettings: [
        AndroidUiSettings(
            // toolbarTitle: 'Cropper',
            // toolbarColor: Colors.deepOrange,
            // toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          aspectRatioPickerButtonHidden: true,
          resetAspectRatioEnabled: false,

          // minimumAspectRatio: 1.0,
        )
      ],
    );

    return croppedFile == null ? null : File(croppedFile.path);
  }
}
