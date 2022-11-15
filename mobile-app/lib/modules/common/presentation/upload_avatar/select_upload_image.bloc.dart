import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:rxdart/rxdart.dart';
import 'package:tello_social_app/modules/core/services/dialog_service.dart';
import 'package:tello_social_app/modules/core/services/interfaces/i_image_picker_provider.dart';
import 'package:tello_social_app/modules/core/services/interfaces/ihttpclient_service.dart';

class SelectUploadImageBloc {
  bool _autoStartUpload = true;
  late Map<String, dynamic> _uploadParams;

  final _imgChooseCtrl = BehaviorSubject<bool>();

  static const double IMG_MAX_WIDTH = 400;
  static const double IMG_MAX_HEIGHT = 400;
  static const double IMG_CROP_RATIO_X = 6;
  static const double IMG_CROP_RATIO_Y = 4;

  late StreamSubscription<bool> _imgChooseStreamSubscription;

  Function? _onUploadFinish;

  // final ImagePickerProvider _imgPicker = locator<ImagePickerProvider>();

  // BehaviorSubject<File> _activeImgCtrl = BehaviorSubject<File>();

  Sink get chooseImage => _imgChooseCtrl.sink;
  // Stream<File> get activeImage => _activeImgCtrl.stream;
  // final _activeImgCtrl = PublishSubject<File>();

  // final _fileCtrl = BehaviorSubject<File?>.seeded(null);

  // Stream<File?> get fileStream => _fileCtrl.stream;

  final _contentCtrl = BehaviorSubject<Either<String, File>?>.seeded(null);
  Stream<Either<String, File>?> get contentStream => _contentCtrl.stream;

  final _imagePathCtrl = BehaviorSubject<String?>.seeded(null);
  Stream<String?> get imagePathStream => _imagePathCtrl.stream;

  // final _uploadProgressCtrl = BehaviorSubject<int?>.seeded(null);
  final _uploadProgressCtrl = StreamController<int>.broadcast();
  Stream<int?> get uploadProgressStream => _uploadProgressCtrl.stream;

  // final CancelableCompleter<bool> _completer = CancelableCompleter(onCancel: () => false);

  Future<File?> _imgOperation(bool isGallery) {
    // final r = locator.get<ImagePickerProvider>();

    if (isGallery) {
      return imgPicker.getImageFromGallery(maxWidth: IMG_MAX_WIDTH, maxHeight: IMG_MAX_HEIGHT
          // ratioX: IMG_CROP_RATIO_X,
          // ratioY: IMG_CROP_RATIO_Y,
          );
    } else {
      return imgPicker.getImageFromCamera(
        maxWidth: IMG_MAX_WIDTH,
        maxHeight: IMG_MAX_HEIGHT,
        // ratioX: IMG_CROP_RATIO_X,
        // ratioY: IMG_CROP_RATIO_Y,
      );
    }
  }

  void setOnUploadFinishResponse(Function? onUploadFinish) {
    _onUploadFinish = onUploadFinish;
  }

  void setAutoStart(bool b) {
    _autoStartUpload = b;
  }

  void addDefaultPath(String url) {
    // _addActiveImage(File.fromUri(Uri(path: url)));
    _addContent(Left(url));
  }

  void _addActiveImage(File file) {
    _addContent(Right(file));
  }

  void _addContent(Either<String, File> content) {
    if (!_contentCtrl.isClosed) {
      _contentCtrl.add(content);
    }
  }

  final IImagePickerProvider imgPicker;
  final IHttpClientService httpClientService;
  SelectUploadImageBloc({
    required this.imgPicker,
    required this.httpClientService,
  }) {
    _imgChooseStreamSubscription = _imgChooseCtrl.listen(_onSelection);
    /*
    _imgChooseStreamSubscription = _imgChooseCtrl.listen((bool isGallery) {
      // _activeImgCtrl.sink.add(null);
      log("_imgChooseCtrl isGallery: $isGallery");
      _imgOperation(isGallery).then<File?>((file) {
        if (file != null) {
          // _activeImgCtrl.sink.add(null);
          // return _saveImage(ProductHelper.getProductImageName(barcode), file);
        }
        return file;
      }).then((file) async {
        _fileCtrl.sink.add(null);
        await Future.delayed(const Duration(seconds: 1));
        return file;
      }).then((file) {
        if (file != null) {
          imageCache.clear();
          log("imgChooseCtrlAction.done ${file.path}");

          // _imagePathCtrl.sink.add(file.path);
          _addActiveImage(file);
          // _activeImgCtrl.sink.add(file);
        }
      }).catchError((err) {
        log("onImagePickError $err");
      });
    });*/

    uploadProgressStream.listen((event) {
      log("uploadProgress $event");
    });
  }
  void _onSelection(bool isGallery) async {
    log("onSelection isGallery: $isGallery");
    try {
      final File? file = await _imgOperation(isGallery);

      if (file != null) {
        log("imgChooseCtrlAction.done ${file.path}");

        _addActiveImage(file);
        if (_autoStartUpload) {
          _startUpload();
        }
      } else {
        log("image pick returns null");
      }
      // imageCache.clear();

      // _imagePathCtrl.sink.add(file.path);

    } on PlatformException catch (e) {
      log("PlatformException $e");
    } catch (e) {
      log("imagePickFailed $e");
    }
  }

  void _startUpload() async {
    try {
      DialogService.showLoading();
      final response = await _upload(
        params: _uploadParams,
      );
      _onUploadFinish?.call(response.toString());
      DialogService.simpleAlert(title: "Done", body: response.toString());
    } catch (e) {
      DialogService.closeLoading();
      DialogService.simpleAlert(title: "Error", body: e.toString());
    }
  }

  String? getSelectedFilePath() =>
      _contentCtrl.value == null ? null : _contentCtrl.value!.fold((l) => l, (r) => r.path);

  Future<dynamic> _upload({
    // required String uploadEndpointSrc,
    required Map<String, dynamic> params,
  }) async {
    //TODO refactor later

    // final String uploadSrc = _contentCtrl.value!.fold((l) => l, (r) => r.path);
    final String? uploadSrc = getSelectedFilePath();

    if (uploadSrc == null) {
      DialogService.simpleAlert(title: "!", body: "No file selected");
    }

    /*final response = await httpClientService.upload(
      // "/Group/UploadGroupAvatar",
      "/Group/UploadCommon",
      filePath: uploadSrc!,
      dtMap: {"type": 1, "extra": _uploadParams["id"]},
      // params: {"id": id},
      uploadProgressCtrl: _uploadProgressCtrl,
    );*/
    final response = await httpClientService.upload(
      "/Media/UploadFile",
      // "/Group/UploadCommon",
      filePath: uploadSrc!,
      params: params,
      // params: {"id": id, "type": "group"},
      uploadProgressCtrl: _uploadProgressCtrl,
    );
    // _uploadProgressCtrl.sink.add(0);

    return response;
  }

  void dispose() {
    _imgChooseStreamSubscription.cancel();
    _contentCtrl.close();
    _uploadProgressCtrl.close();
    // _activeImgCtrl = null;
    _imgChooseCtrl.close();
  }

  Future<bool> _clearImageMemCache(File file) {
    return FileImage(file).evict();
  }

  void addUploadParams(Map<String, dynamic> p_uploadParams) {
    _uploadParams = p_uploadParams;
  }
}
