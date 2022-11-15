import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:tello_social_app/modules/core/error/failure.dart';

mixin EitherMixin {
  // Future<Either<F, T>> runWithEither<F, T>(Future<T> Function() action, F Function(String)? errorFunc) async {
  Future<Either<F, T>> runWithEither<F, T>(Future<T> Function() action) async {
    try {
      final result = await action();
      return right(result);
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      return left(GeneralFailure(message: e.toString(), stackTrace: s) as F);
      // log(e.toString());
      // return left(errorFunc(e.toString()));
    }
  }
}
