import 'package:dartz/dartz.dart';

import 'package:tello_social_app/modules/chat/domain/entities/group.entity.dart';
import 'package:tello_social_app/modules/chat/domain/repositories/i_group.repo.dart';
import 'package:tello_social_app/modules/core/error/failure.dart';
import 'package:tello_social_app/modules/core/usecases/iusecase.dart';

class GroupCreateUseCase implements IUseCase<GroupEntity, CreateGroupParams> {
  final IGroupRepo repo;

  GroupCreateUseCase(this.repo);
  @override
  Future<Either<IFailure, GroupEntity>> call(CreateGroupParams params) {
    return repo.create(params.toMap(), avatarFilePath: params.avatarPath);
  }
}

class CreateGroupParams {
  final String name;
  final String? description;
  final List<String>? members; //members phoneNumber or id refactor to ContactEntity
  final String? avatarPath;
  CreateGroupParams({
    required this.name,
    this.members,
    this.description,
    this.avatarPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'phones': members ?? [],
    };
  }
}
