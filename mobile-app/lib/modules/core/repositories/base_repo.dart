import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:tello_social_app/modules/core/error/failure.dart';

export 'package:dartz/dartz.dart';

abstract class BaseRepo {
  BaseRepo() {
    log("BaseRepo");
  }
  Future<Either<BaseFailure, T>> runWithEither<T>(Future<T> Function() action) async {
    try {
      final result = await action();
      // final resultStr = JsonHelper.prettyPrintJson("$result");
      // log("RepoResponse=> $result");

      return right(result);
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      if (e is TypeError) {
        return left(RuntimeFailure(message: e.toString()));
      }

      return left(GeneralFailure(message: e.toString(), stackTrace: s));
      // log(e.toString());
      // return left(errorFunc(e.toString()));
    }
  }
}
