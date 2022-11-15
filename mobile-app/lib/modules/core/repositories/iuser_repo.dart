import 'package:dartz/dartz.dart';
import 'package:tello_social_app/modules/core/error/failure.dart';
import 'package:tello_social_app/modules/user/domain/entities/app_user.dart';

abstract class IUserRepo {
  // Stream<AuthUser?> get onAuthChanged;
  Future<Either<IFailure, void>> setDisplayName(String displaynName);
  Future<Either<IFailure, void>> setPhoto(String imgPath);
  Future<Either<IFailure, AppUser?>> getDetails({String? userId});
}
