import 'package:tello_social_app/modules/core/helpers/date_helper.dart';

class AppUser {
  final String id;
  final String phoneNumber;
  final DateTime lastSeen;
  final bool isActive;
  final String? displayName;
  final String? avatar;
  AppUser({
    required this.id,
    required this.phoneNumber,
    required this.lastSeen,
    required this.isActive,
    this.displayName,
    this.avatar,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'lastSeen': lastSeen.millisecondsSinceEpoch,
      'isActive': isActive,
      'displayName': displayName,
      'imgUrl': avatar,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] ?? '',
      phoneNumber: map['phone'] ?? '',
      lastSeen: DateHelper.unixSecondsToDate(map["lastSeen"] ?? 0),
      // lastSeen: DateTime.fromMillisecondsSinceEpoch(map['lastSeen']),
      isActive: map['isActive'] ?? false,
      displayName: map['nickname'],
      avatar: map['avatar'],
    );
  }
  @override
  String toString() {
    return 'AppUser(id: $id, phoneNumber: $phoneNumber, lastSeen: $lastSeen, isActive: $isActive, displayName: $displayName, imgUrl: $avatar)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppUser &&
        other.id == id &&
        other.phoneNumber == phoneNumber &&
        other.lastSeen == lastSeen &&
        other.isActive == isActive &&
        other.displayName == displayName &&
        other.avatar == avatar;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        phoneNumber.hashCode ^
        lastSeen.hashCode ^
        isActive.hashCode ^
        displayName.hashCode ^
        avatar.hashCode;
  }
}
