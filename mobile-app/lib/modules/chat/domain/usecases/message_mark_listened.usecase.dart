import '../repositories/i_message.repo.dart';
import 'package:tello_social_app/modules/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:tello_social_app/modules/core/usecases/iusecase.dart';

class MessageMarkListenedUseCase implements IUseCase<bool, String> {
  final IMessageRepo repo;

  MessageMarkListenedUseCase(this.repo);
  @override
  Future<Either<IFailure, bool>> call(String id) {
    return repo.markMessageListened(id);
  }
}
