import 'dart:convert';

import 'package:tello_social_app/modules/chat/domain/entities/audio_file.entity.dart';
import 'package:tello_social_app/modules/contact/domain/entities/contact.entity.dart';

class GroupMessageEntity {
  final String id;
  final String ownerId;
  final String groupId;
  final AudioFileEntity audioFile;
  final DateTime createdAt;
  final bool hasListened;
  final ContactEntity? contact;
  GroupMessageEntity({
    required this.id,
    required this.ownerId,
    required this.groupId,
    required this.audioFile,
    required this.createdAt,
    this.hasListened = false,
    this.contact,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerId': ownerId,
      'groupId': groupId,
      'hasListened': hasListened,
      'audioFile': audioFile.toMap(),
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory GroupMessageEntity.fromMap(Map<String, dynamic> map) {
    return GroupMessageEntity(
      id: map['id'],
      ownerId: map['ownerId'],
      groupId: map['groupId'],
      contact: map["contact"] != null ? ContactEntity.fromMap(map["contact"]) : null,
      hasListened: map['hasListened'] ?? false,
      audioFile: AudioFileEntity.fromMap(map['audioFile']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupMessageEntity.fromJson(String source) => GroupMessageEntity.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AudioMessageEntity(id: $id, ownerId: $ownerId, groupId: $groupId, audioFile: $audioFile, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GroupMessageEntity &&
        other.id == id &&
        other.ownerId == ownerId &&
        other.groupId == groupId &&
        other.audioFile == audioFile &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ ownerId.hashCode ^ groupId.hashCode ^ audioFile.hashCode ^ createdAt.hashCode;
  }
}
