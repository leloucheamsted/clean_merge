import 'package:dartz/dartz.dart';
import 'package:tello_social_app/modules/core/error/failure.dart';

abstract class ISessionRepo {
  Future<Either<IFailure, bool>> get isExists;
  Future<Either<IFailure, void>> saveToken(String token);
  Future<Either<IFailure, String?>> getToken();

  Future<Either<IFailure, void>> savePhone(String phoneNumber);
  Future<Either<IFailure, String?>> getPhoneNumber();

  Future<Either<IFailure, void>> clearSession();
}
