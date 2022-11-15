import 'package:tello_social_app/modules/user/domain/entities/app_user.dart';

class Recipient {
  String? recipientType;
  String? recipientId;
  // For groups we need to specify the current list of users so people
  // will not recieve messages from before they joined the group
  List<AppUser>? userList;

  Recipient({this.recipientType, this.recipientId, this.userList});

  Map<String, dynamic> toMap() {
    return {
      'recipientType': recipientType,
      'recipientId': recipientId,
      'userList': userList?.map((x) => x.toMap()).toList(),
    };
  }

  factory Recipient.fromMap(Map<String, dynamic> map) {
    return Recipient(
      recipientType: map['recipientType'],
      recipientId: map['recipientId'],
      userList: map['userList'] != null ? List<AppUser>.from(map['userList']?.map((x) => AppUser.fromMap(x))) : null,
    );
  }
}
