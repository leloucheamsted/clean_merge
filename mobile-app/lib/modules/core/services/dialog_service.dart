import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:tello_social_app/modules/core/services/interfaces/i_dialog_service.dart';

class DialogService {
  static GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  // const DialogService._();
  // static BuildContext get _context => navigationKey.currentContext!;
  static BuildContext get _context => navigationKey.currentState!.overlay!.context;
  // factory DialogService.alert(String content, {Key? key}) => DialogService._().simpleAlert();
  static showToast({required String msg, Duration? duration}) {
    ScaffoldMessenger.of(_context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: duration ?? const Duration(milliseconds: 1200),
    ));
  }

  static TextEditingController? _textInputCtrl;
  static TextEditingController get textInputCtrl {
    _textInputCtrl ??= TextEditingController();
    return _textInputCtrl!;
  }

  static void dispose() {
    // _textInputCtrl?.dispose();
  }

  static Future<String?> showTextInputDialog({String? title, String? hint, String? defaultValue}) async {
    closeLoading();
    final Future<String?> res = showDialog(
        context: _context,
        builder: (context) {
          return AlertDialog(
            title: Text(title ?? "insert"),
            content: TextField(
              controller: textInputCtrl..text = defaultValue ?? "",
              autofocus: true,
              autocorrect: false,
              decoration: InputDecoration(hintText: hint),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                child: const Text('Apply'),
                onPressed: () => Navigator.pop(context, _textInputCtrl?.text),
              ),
            ],
          );
        });
    _textInputCtrl?.dispose();
    _textInputCtrl = null;
    return res;
  }

  static Future<T?> simpleAlert<T>({
    required String title,
    required String body,
    // BuildContext? context,
    String btnLabel = "Ok",
  }) {
    /*if (context == null) {
      context = navigationKey.currentContext;
    }*/
    // closeDialog();
    closeLoading();
    return showDialog<T>(
      context: _context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            TextButton(
              child: Text(btnLabel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static bool _isLoadingOpened = false;
  static Future<void> showLoading() {
    _isLoadingOpened = true;
    return _showWidget(
        child: const Center(
      child: CircularProgressIndicator(),
    ));
  }

  static Future<void> copyToClipBoard(String str) async {
    await Clipboard.setData(ClipboardData(text: str));
    showToast(msg: "Text copied to clipboard");
  }

  static closeLoading() {
    if (_isLoadingOpened) {
      _closeDialog();
      _isLoadingOpened = false;
    }
  }

  static _closeDialog() {
    Navigator.of(_context, rootNavigator: true).pop();
  }

  static Future<bool?> _showWidget({
    required Widget child,
    BuildContext? context,
  }) async {
    return showDialog<bool>(
        context: _context,
        // context: context ?? navigationKey.currentContext!,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return SimpleDialog(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            children: <Widget>[
              Center(
                child: CircularProgressIndicator(),
              )
            ],
          );
          return AlertDialog(
            // title: Text("Alert Dialog"),
            content: child,
          );
        });
  }
}
