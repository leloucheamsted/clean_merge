import 'package:dartz/dartz.dart';
import 'package:tello_social_app/modules/core/error/failure.dart';

abstract class ISimCountryRepo {
  Future<Either<IFailure, String?>> getSIMCountryCode();
}
