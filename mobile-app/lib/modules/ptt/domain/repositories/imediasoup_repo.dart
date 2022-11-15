import 'package:dartz/dartz.dart';
import 'package:tello_social_app/modules/core/error/failure.dart';

import '../entities/transport_response.entity.dart';

abstract class IMediasoupRepo {
  Future<Either<ServerFailure, Map<String, dynamic>>> getRouterCapabilities();
  Future<Either<ServerFailure, TransportResponseEntity>> createTransport(Map data);
}
