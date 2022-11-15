import 'dart:convert';

enum InvitationStatus { accepted, rejected, pending }

class GroupMemberEntity {
  // final String groupId;
  final String? userId;
  final String phoneNumber;
  final String? avatar;
  final String displayName;
  final String memberStatus; //TODO convert to enum
  final InvitationStatus groupInvitationStatus;
  final String? appStatus;

  bool get isDisplayNameSameAsPhone => displayName == phoneNumber;
  GroupMemberEntity({
    this.userId,
    required this.phoneNumber,
    this.avatar,
    required this.displayName,
    required this.memberStatus,
    this.groupInvitationStatus = InvitationStatus.pending,
    this.appStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'phoneNumber': phoneNumber,
      'avatar': avatar,
      'displayName': displayName,
      'memberStatus': memberStatus,
      "groupInvitationStatus": groupInvitationStatus.name,
      'appStatus': appStatus,
    };
  }

  factory GroupMemberEntity.fromMap(Map<String, dynamic> map) {
    return GroupMemberEntity(
      userId: map['userId'],
      phoneNumber: map['phoneNumber'] ?? map['displayName'],
      avatar: map['avatar'],
      displayName: map['displayName'] ?? '-name',
      memberStatus: map['memberStatus'] ?? '-memberSt',
      groupInvitationStatus: map["groupInvitationStatus"] == null
          ? InvitationStatus.pending
          : InvitationStatus.values[map["groupInvitationStatus"]],
      appStatus: map['appStatus'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupMemberEntity.fromJson(String source) => GroupMemberEntity.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GroupMemberEntity(userId: $userId, phoneNumber: $phoneNumber, avatar: $avatar, displayName: $displayName, memberStatus: $memberStatus, appStatus: $appStatus)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GroupMemberEntity &&
        other.userId == userId &&
        other.phoneNumber == phoneNumber &&
        other.avatar == avatar &&
        other.displayName == displayName &&
        other.memberStatus == memberStatus &&
        other.appStatus == appStatus;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        phoneNumber.hashCode ^
        avatar.hashCode ^
        displayName.hashCode ^
        memberStatus.hashCode ^
        appStatus.hashCode;
  }
}
