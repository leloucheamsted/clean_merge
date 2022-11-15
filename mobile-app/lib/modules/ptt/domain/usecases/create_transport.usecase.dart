import 'package:dartz/dartz.dart';

import 'package:tello_social_app/modules/core/error/failure.dart';
import 'package:tello_social_app/modules/core/usecases/iusecase.dart';
import 'package:tello_social_app/modules/ptt/domain/entities/transport_response.entity.dart';
import 'package:tello_social_app/modules/ptt/domain/repositories/imediasoup_repo.dart';

class CreateTransportUseCase implements IUseCase<TransportResponseEntity, CreateTransportParams> {
  final IMediasoupRepo repo;

  CreateTransportUseCase(this.repo);
  @override
  Future<Either<IFailure, TransportResponseEntity>> call(CreateTransportParams params) async {
    return repo.createTransport(params.toMap());
  }
}

class CreateTransportParams {
  final bool isProducing;
  final bool isConsuming;
  final bool? forceTcp;
  final Map<String, dynamic> sctpCapabilities;
  CreateTransportParams({
    required this.isProducing,
    required this.isConsuming,
    required this.sctpCapabilities,
    this.forceTcp = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'producing': isProducing,
      'consuming': isConsuming,
      'forceTcp': forceTcp,
      'sctpCapabilities': sctpCapabilities,
    };
  }
}
