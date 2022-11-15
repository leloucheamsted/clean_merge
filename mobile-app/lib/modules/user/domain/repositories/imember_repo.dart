import 'package:dartz/dartz.dart';
import 'package:tello_social_app/modules/core/error/failure.dart';

abstract class IMemberRepo {
  // Stream<AuthUser?> get onAuthChanged;
  Future<Either<ServerFailure, void>> invite(String phoneNumber);
  Future<Either<ServerFailure, void>> setDisplayName(String value);
  Future<Either<ServerFailure, void>> uploadPhoto(Map data);
}
