class GroupPttMemberEntity {
  final String groupId;
  final String phoneNumber;
  final String? userId;
  GroupPttMemberEntity({
    required this.groupId,
    required this.phoneNumber,
    this.userId,
  });

  GroupPttMemberEntity copyWith({
    String? groupId,
    String? userId,
    String? phoneNumber,
  }) {
    return GroupPttMemberEntity(
      groupId: groupId ?? this.groupId,
      userId: userId ?? this.userId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'userId': userId,
      'phoneNumber': phoneNumber,
    };
  }

  factory GroupPttMemberEntity.fromMap(Map<String, dynamic> map) {
    return GroupPttMemberEntity(
      groupId: map['groupId'],
      userId: map['userId'],
      phoneNumber: map['userPhoneNumber'],
    );
  }
  @override
  String toString() => 'GroupPttMemberEntity(groupId: $groupId, userId: $userId, phoneNumber: $phoneNumber)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GroupPttMemberEntity &&
        other.groupId == groupId &&
        other.userId == userId &&
        other.phoneNumber == phoneNumber;
  }

  @override
  int get hashCode => groupId.hashCode ^ userId.hashCode ^ phoneNumber.hashCode;
}
