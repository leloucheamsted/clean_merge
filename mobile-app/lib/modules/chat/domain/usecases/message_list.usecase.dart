import 'package:dartz/dartz.dart';
import '../repositories/i_message.repo.dart';

import 'package:tello_social_app/modules/core/error/failure.dart';
import 'package:tello_social_app/modules/core/usecases/iusecase.dart';

import '../entities/group_message.entity.dart';

class MessageListUseCase implements IUseCase<List<GroupMessageEntity>, MessageListParams> {
  final IMessageRepo repo;

  MessageListUseCase(this.repo);

  @override
  Future<Either<IFailure, List<GroupMessageEntity>>> call(MessageListParams params) {
    return repo.fetchMessages(params.groupId);
  }
}

class MessageListParams {
  final String groupId;
  MessageListParams({
    required this.groupId,
  });
}
