import 'dart:io';

import 'package:tello_social_app/modules/chat/domain/entities/group_message.entity.dart';
import 'package:tello_social_app/modules/chat/domain/entities/signed_url_response.dart';
import 'package:tello_social_app/modules/chat/domain/errors/group_failure.dart';
import 'package:tello_social_app/modules/chat/domain/entities/group.entity.dart';
import 'package:dartz/dartz.dart';
import 'package:tello_social_app/modules/chat/domain/repositories/i_message.repo.dart';
import 'package:tello_social_app/modules/chat/infra/datasource/i_group_datasource.dart';
import 'package:tello_social_app/modules/chat/infra/datasource/i_message_datasource.dart';
import 'package:tello_social_app/modules/core/error/failure.dart';
import 'package:tello_social_app/modules/core/repositories/either.mixin.dart';

class MessageRepository with EitherMixin implements IMessageRepo {
  final IMessageDataSource _dataSource;

  MessageRepository(this._dataSource);

  Future<Either<GroupFailure, T>> _run<T>(Future<T> Function() action) {
    // return runWithEither<GroupFailure, T>(() => action(), (e) => GroupFailure.serverError(e.toString()));
    return runWithEither<GroupFailure, T>(() => action());
  }

  @override
  Future<Either<GroupFailure, List<GroupMessageEntity>>> fetchMessages(String groupId) {
    return _run(() => _dataSource.fetchMessages(groupId));
  }

  @override
  Future<Either<GroupFailure, bool>> markMessageListened(String messageId) {
    return _run<bool>(() => _dataSource.markMessageListened(messageId));
  }

  @override
  Future<Either<IFailure, SignedUrlResponse>> getSignedUrl(String fileName) {
    // TODO: implement getSignedUrl
    throw UnimplementedError();
  }

  @override
  Future<Either<IFailure, void>> uploadAudioFile(String signedUrl, File audioFile) {
    // TODO: implement uploadAudioFile
    throw UnimplementedError();
  }
}
