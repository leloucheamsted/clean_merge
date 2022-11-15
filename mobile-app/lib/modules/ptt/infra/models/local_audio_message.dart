import 'dart:convert';

import 'package:tello_social_app/modules/ptt/infra/models/chat_user_model.dart';

class LocalAudioMessage {
  String? lng;
  String? lat;
  String? filePath;
  String? fileUrl;
  int? fileDurationMs;
  String? mimeType;

  // We use either 'groupId' for sending .this to the active group or 'groupIds' to multiple ones
  String? groupId;
  final List<String> groupIds = [];

  DateTime? createdAt;
  int? createdAtTimestamp;
  String? txId;
  ChatUser? owner;
  List<String?>? recipients;
  bool isNeedTranscode;

  bool get forAllGroups => groupIds.isNotEmpty;

  LocalAudioMessage({
    this.createdAt,
    this.txId,
    this.lng,
    this.lat,
    this.filePath,
    this.fileUrl,
    this.fileDurationMs,
    this.mimeType,
    this.createdAtTimestamp,
    this.groupId,
    this.owner,
    this.recipients,
    this.isNeedTranscode = false,
  });

  LocalAudioMessage.fromMap(Map<String, dynamic> map)
      : createdAt = map['createdAt'] == null ? null : DateTime.parse(map['createdAt'] as String),
        createdAtTimestamp = map['createdAtTimestamp'] as int?,
        filePath = map['recordingUrl'] as String?,
        fileUrl = map['fileUrl'] as String?,
        fileDurationMs = map['fileDurationMs'] as int?,
        txId = map['txId'] as String?,
        mimeType = map['mimeType'] as String?,
        groupId = map['groupId'] as String?,
        isNeedTranscode = map['isNeedTranscode'] as bool? ?? false,
        owner = map['owner'] != null ? ChatUser.fromMap(map['owner'] as Map<String, dynamic>) : null,
        recipients = map['recipients'] != null ? List<String>.from(map['recipients'] as List<dynamic>) : null {
    groupIds.addAll(List<String>.from(json.decode(map['groupIds'] as String) as List<dynamic>));
  }

  Map<String, dynamic> toMap() => {
        'txId': txId,
        'recordingUrl': filePath,
        'fileUrl': fileUrl,
        'fileDurationMs': fileDurationMs,
        'createdAt': createdAt?.toIso8601String(),
        'createdAtTimestamp': createdAtTimestamp,
        'mimeType': mimeType,
        'groupId': groupId,
        'groupIds': json.encode(groupIds),
        'isNeedTranscode': isNeedTranscode,
        'owner': owner!.toMap(),
        'recipients': recipients,
      };

  Map<String, dynamic> toMapForServer() {
    return {
      if (forAllGroups) 'groupIds': groupIds else 'groupId': groupId,
      'owner': owner!.toMapForServer(),
      'audioFile': {
        'durationMs': fileDurationMs,
        'url': fileUrl,
      },
      'createdAt': createdAtTimestamp,
      if (!forAllGroups) 'recipientUserIds': recipients,
    };
  }

  LocalAudioMessage copyWith({
    String? long,
    String? lat,
    String? filePath,
    String? fileUrl,
    int? fileDurationMs,
    String? mimeType,
    String? groupId,
    DateTime? createdAt,
    int? createdAtTimestamp,
    String? txId,
    ChatUser? owner,
    List<String?>? recipients,
    bool? isNeedTranscode,
  }) {
    return LocalAudioMessage(
      lng: long ?? this.lng,
      lat: lat ?? this.lat,
      filePath: filePath ?? this.filePath,
      fileUrl: fileUrl ?? this.fileUrl,
      fileDurationMs: fileDurationMs ?? this.fileDurationMs,
      mimeType: mimeType ?? this.mimeType,
      groupId: groupId ?? this.groupId,
      createdAt: createdAt ?? this.createdAt,
      createdAtTimestamp: createdAtTimestamp ?? this.createdAtTimestamp,
      txId: txId ?? this.txId,
      owner: owner ?? this.owner,
      recipients: recipients ?? this.recipients,
      isNeedTranscode: isNeedTranscode ?? false,
    );
  }

  void updateWith({
    String? long,
    String? lat,
    String? filePath,
    String? fileUrl,
    int? fileDurationMs,
    String? mimeType,
    String? groupId,
    DateTime? createdAt,
    int? createdAtTimestamp,
    String? txId,
    ChatUser? owner,
    List<String?>? recipients,
    bool? isNeedTranscode,
  }) {
    this.lng = long ?? this.lng;
    this.lat = lat ?? this.lat;
    this.filePath = filePath ?? this.filePath;
    this.fileUrl = fileUrl ?? this.fileUrl;
    this.fileDurationMs = fileDurationMs ?? this.fileDurationMs;
    this.mimeType = mimeType ?? this.mimeType;
    this.groupId = groupId ?? this.groupId;
    this.createdAt = createdAt ?? this.createdAt;
    this.createdAtTimestamp = createdAtTimestamp ?? this.createdAtTimestamp;
    this.txId = txId ?? this.txId;
    this.owner = owner ?? this.owner;
    this.recipients = recipients ?? this.recipients;
    this.isNeedTranscode = isNeedTranscode ?? this.isNeedTranscode;
  }
}
