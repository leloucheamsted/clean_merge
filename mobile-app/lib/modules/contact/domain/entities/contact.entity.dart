class ContactEntity {
  final String phoneNumber; //ignore phone number null or empty contact during fetch
  final String? uniqueId;
  final String? userId;
  final String phoneBookId;
  final String displayName;
  final String? countryCode;
  final bool isTelloMember;
  bool isOnline;
  final String? avatar;
  bool isMember = false; //TODO: move to ContactSelectModel
  // bool isOnline = false; //TODO: move to ContactSelectModel

  ContactEntity({
    // this.isMember = false,
    required this.phoneNumber,
    this.uniqueId,
    this.userId,
    required this.phoneBookId,
    required this.displayName,
    this.countryCode,
    this.isTelloMember = false,
    this.isOnline = false,
    this.avatar,
    this.isMember = false,
  });

  // String get displayName => name ?? phoneNumber;

  ContactEntity copyWith({
    String? phoneNumber,
    String? uniqueId,
    String? userId,
    String? phoneBookId,
    String? displayName,
    String? countryCode,
    bool? isTelloMember,
    bool? isOnline,
    String? avatar,
    bool? isMember,
  }) {
    return ContactEntity(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      uniqueId: uniqueId ?? this.uniqueId,
      userId: userId ?? this.userId,
      phoneBookId: phoneBookId ?? this.phoneBookId,
      displayName: displayName ?? this.displayName,
      countryCode: countryCode ?? this.countryCode,
      isTelloMember: isTelloMember ?? this.isTelloMember,
      isOnline: isOnline ?? this.isOnline,
      avatar: avatar ?? this.avatar,
      isMember: isMember ?? this.isMember,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'phoneNumber': phoneNumber,
      'uniqueId': uniqueId,
      'userId': userId,
      'phoneBookId': phoneBookId,
      'displayName': displayName,
      // 'countryCode': countryCode,
      'isTelloMember': isTelloMember,
      // 'isOnline': isOnline,
      'avatar': avatar
    };
  }

  factory ContactEntity.fromMap(Map<String, dynamic> map) {
    return ContactEntity(
      phoneNumber: map['phoneNumber'] ?? '',
      uniqueId: map['uniqueId'],
      userId: map['userId'],
      phoneBookId: map['phoneBookId'] ?? '',
      displayName: map['displayName'],
      countryCode: map['countryCode'],
      isTelloMember: map['isTelloMember'],
      isOnline: map['isOnline'],
      avatar: map['avatar'],
      isMember: map['isMember'] ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ContactEntity &&
        other.phoneNumber == phoneNumber &&
        other.uniqueId == uniqueId &&
        other.phoneBookId == phoneBookId &&
        other.displayName == displayName &&
        other.countryCode == countryCode &&
        other.isTelloMember == isTelloMember &&
        other.isOnline == isOnline &&
        other.avatar == avatar &&
        other.isMember == isMember;
  }

  @override
  int get hashCode {
    return phoneNumber.hashCode ^
        uniqueId.hashCode ^
        phoneBookId.hashCode ^
        displayName.hashCode ^
        countryCode.hashCode ^
        isTelloMember.hashCode ^
        isOnline.hashCode ^
        avatar.hashCode ^
        isMember.hashCode;
  }

  @override
  String toString() {
    return 'ContactEntity(phoneNumber: $phoneNumber, uniqueId: $uniqueId, phoneBookId: $phoneBookId, name: $displayName, countryCode: $countryCode, isAppUser: $isTelloMember, isOnline: $isOnline, avatar: $avatar, isMember: $isMember)';
  }
}
