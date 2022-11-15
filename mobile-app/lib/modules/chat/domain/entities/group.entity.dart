import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import 'package:tello_social_app/modules/chat/domain/entities/group_ptt_member.entity.dart';
import 'package:tello_social_app/modules/core/helpers/date_helper.dart';

import 'group_member.entity.dart';
import 'group_message.entity.dart';

class GroupEntity {
  final String id;
  final String owner;
  final String name;
  final String? avatar;
  final String? description;
  // final List<String>? members;
  final int membersCount;
  final List<GroupMemberEntity> members;
  final List<GroupPttMemberEntity> attachedMembers;
  final List<GroupMessageEntity>? messages;
  final DateTime createdAt;
  final bool isOwner;
  final bool isActive;
  GroupEntity({
    required this.id,
    required this.owner,
    required this.name,
    this.avatar,
    this.description,
    required this.membersCount,
    required this.members,
    required this.attachedMembers,
    this.messages,
    required this.createdAt,
    required this.isOwner,
    required this.isActive,
  });

  // List<GroupMemberEntity>? _membersExcludeMe;
  // List<GroupMemberEntity>? get membersExcludeMe => _membersExcludeMe;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'owner': owner,
      'name': name,
      'avatar': avatar,
      'description': description,
      'membersCount': membersCount,
      'members': members.map((x) => x.toMap()).toList(),
      'attachedMembers': attachedMembers.map((x) => x.toMap()).toList(),
      'messages': messages?.map((x) => x?.toMap())?.toList(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'isOwner': isOwner,
      'isActive': isActive,
    };
  }

  factory GroupEntity.fromMap(Map<String, dynamic> map) {
    return GroupEntity(
      id: map['id'] ?? '',
      owner: map['owner'] ?? '',
      name: map['name'] ?? '',
      avatar: map['avatar'],
      description: map['description'],
      membersCount: map['membersCount']?.toInt() ?? 0,
      members: map['members'] == null
          ? []
          : List<GroupMemberEntity>.from(map['members']?.map((x) => GroupMemberEntity.fromMap(x))),
      attachedMembers: map['pptMembers'] == null
          ? []
          : List<GroupPttMemberEntity>.from(map['pptMembers']?.map((x) => GroupPttMemberEntity.fromMap(x))),
      messages: map['messages'] != null
          ? List<GroupMessageEntity>.from(map['messages']?.map((x) => GroupMessageEntity.fromMap(x)))
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      isOwner: map['isOwner'] ?? false,
      isActive: map['isActive'] ?? false,
    );
  }

  @override
  String toString() {
    return 'GroupEntity(id: $id, owner: $owner, name: $name, avatar: $avatar, description: $description, membersCount: $membersCount, members: $members, attachedMembers: $attachedMembers, messages: $messages, createdAt: $createdAt, isOwner: $isOwner, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is GroupEntity &&
        other.id == id &&
        other.owner == owner &&
        other.name == name &&
        other.avatar == avatar &&
        other.description == description &&
        other.membersCount == membersCount &&
        listEquals(other.members, members) &&
        listEquals(other.attachedMembers, attachedMembers) &&
        listEquals(other.messages, messages) &&
        other.createdAt == createdAt &&
        other.isOwner == isOwner &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        owner.hashCode ^
        name.hashCode ^
        avatar.hashCode ^
        description.hashCode ^
        membersCount.hashCode ^
        members.hashCode ^
        attachedMembers.hashCode ^
        messages.hashCode ^
        createdAt.hashCode ^
        isOwner.hashCode ^
        isActive.hashCode;
  }

  GroupEntity copyWith({
    String? id,
    String? owner,
    String? name,
    String? avatar,
    String? description,
    int? membersCount,
    List<GroupMemberEntity>? members,
    List<GroupPttMemberEntity>? attachedMembers,
    List<GroupMessageEntity>? messages,
    DateTime? createdAt,
    bool? isOwner,
    bool? isActive,
  }) {
    return GroupEntity(
      id: id ?? this.id,
      owner: owner ?? this.owner,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      description: description ?? this.description,
      membersCount: membersCount ?? this.membersCount,
      members: members ?? this.members,
      attachedMembers: attachedMembers ?? this.attachedMembers,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      isOwner: isOwner ?? this.isOwner,
      isActive: isActive ?? this.isActive,
    );
  }
}
