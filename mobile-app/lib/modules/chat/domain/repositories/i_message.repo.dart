import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:tello_social_app/modules/core/error/failure.dart';
import '../entities/group_message.entity.dart';
import '../entities/signed_url_response.dart';

abstract class IMessageRepo {
  Future<Either<IFailure, List<GroupMessageEntity>>> fetchMessages(String groupId);
  Future<Either<IFailure, bool>> markMessageListened(String messageId);

  Future<Either<IFailure, SignedUrlResponse>> getSignedUrl(String fileName);

  Future<Either<IFailure, void>> uploadAudioFile(String signedUrl, File audioFile);
}
