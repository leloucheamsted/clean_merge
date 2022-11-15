import 'package:flutter/material.dart';

abstract class IDialogService {
  Future<void> simpleAlert({
    required String title,
    required String body,
    BuildContext? context,
    String btnLabel = "Ok",
  });
  Future<bool?> showWidget({
    required Widget child,
    BuildContext? context,
  });
}
