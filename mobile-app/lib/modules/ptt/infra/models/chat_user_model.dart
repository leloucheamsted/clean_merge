import 'package:uuid/uuid.dart';

class ChatUser {
  // final BehaviorSubject<bool> _onlineCtrl = BehaviorSubject<bool>.seeded(false);
  // Stream<bool> get isOnline => _onlineCtrl.stream;
  // Function(bool) get setOnline => _onlineCtrl.sink.add;

  String id, nickName, firstName, lastName, avatar;
  String? email, phone;

  bool isOnline = false;
  // RxBool isOnline = false.obs,
  bool isTransmitting = false;
  bool hasActiveSession = false;
  Role? role;
  int? rating;

  int? onlineUpdatedAt;
  bool? hasGPSSignal;
  bool? faceIdLoginEnabled = true;

  String get fullName => '$firstName $lastName';

  bool get isSupervisor => role!.id == 'Supervisor';

  bool get isGuard => role!.id == 'Guard';

  bool get isAdmin => role!.id == 'Admin';

  bool get isDriver => role!.id == 'Driver';

  bool get isCustomer => role!.id == 'Customer';

  //prevent incorrect avatar image url rendering _ALL
  String? get validAvatarUrl => avatar != null && avatar!.startsWith("http") ? avatar : null;

  ChatUser({
    required this.id,
    required this.nickName,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    this.role,
    this.rating,
    this.onlineUpdatedAt,
    this.hasGPSSignal,
  });

  // void updateUserDetailsFromMap(Map<String, dynamic> m) {
  //   nickName = m['profile']['nickname'] as String;
  //   firstName = m['profile']['firstName'] as String;
  //   lastName = m['profile']['lastName'] as String;
  //   rating = m['rating'] == null
  //       ? 0.0
  //       : m['rating'] as int;
  //   avatar = m['profile']['avatar'] as String;
  //   location = m['userLocation'] != null
  //       ? UserLocation.fromMap(m['userLocation'] as Map<String, dynamic>).obs
  //       : Rx<UserLocation>();
  //   deviceInfo = m['device'] != null
  //       ? DeviceInfo.fromMap(m['device'] as Map<String, dynamic>).obs
  //       : DeviceInfo.createEmpty().obs;
  //   role = Role.fromMap(m["role"] as Map<String, dynamic>);
  //   isOnline.value = m['isOnline'] as bool;
  //   onlineUpdatedAt = m['onlineUpdatedAt'] as int;
  // }

  void updateFromUser(ChatUser user, {bool completely = true}) {
    nickName = user.nickName;
    firstName = user.firstName;
    lastName = user.lastName;
    rating = user.rating;
    avatar = user.avatar;
    //deviceInfo.value = user.deviceInfo.value;
    role = user.role;
    hasGPSSignal = user.hasGPSSignal;
    if (completely) {
      isOnline = user.isOnline;
      onlineUpdatedAt = user.onlineUpdatedAt;
    }
  }

  ChatUser clone() {
    return ChatUser.fromMap(toMap());
  }

  ChatUser.fromMap(Map<String, dynamic> m)
      : id = m['id'] as String,
        email = m['email'] as String?,
        phone = m['phone'] as String?,
        nickName = m['profile']['nickname'] as String,
        firstName = m['profile']['firstName'] as String,
        lastName = m['profile']['lastName'] as String,
        avatar = m['profile']['avatar'] as String,
        // ignore: avoid_bool_literals_in_conditional_expressions
        hasGPSSignal = m['noGps'] != null ? !(m['noGps'] as bool) : false,
        role = Role.fromMap(m['role'] as Map<String, dynamic>),
        rating = m['rating'] != null ? m['rating'] as int? : 0,
        onlineUpdatedAt = m['onlineUpdatedAt'] != null ? m['onlineUpdatedAt'] as int? : 0 {
    isOnline = m['isOnline'] as bool;
    if (m['hasActiveSession'] != null) {
      hasActiveSession = m['hasActiveSession'] as bool;
    } else {
      hasActiveSession = false;
    }
  }

  Map<String, Object?> toMap() {
    final map = {
      'id': id,
      'email': email,
      'phone': phone,
      'profile': {
        'nickname': nickName,
        'firstName': firstName,
        'lastName': lastName,
        'avatar': avatar,
      },
      'role': role!.toMap(),
      'rating': rating,
      'isOnline': isOnline,
      'hasGPSSignal': hasGPSSignal,
      'onlineUpdatedAt': onlineUpdatedAt,
      'hasActiveSession': hasActiveSession
    };
    return map;
  }

  Map<String, Object?> toMapForServer() {
    final map = toMap();

    return map;
  }

  // ignore: prefer_constructors_over_static_methods
  static ChatUser unknownUser(Map<String, dynamic>? userData) {
    return ChatUser(
      id: userData!["id"] as String,
      nickName: userData!["profile"]["nickname"] as String,
      firstName: userData!["profile"]["firstName"] as String,
      lastName: userData!["profile"]["lastName"] as String,
      avatar: userData!["profile"]["avatar"] as String,
      hasGPSSignal: false,
      role: Role.fromMap({"id": "", "title": ""}),
      rating: 0,
      onlineUpdatedAt: 0,
    );
  }

  static ChatUser unknownUserId(String? userId) {
    return ChatUser(
      id: userId ?? const Uuid().v1(),
      nickName: "Unknown",
      firstName: "Unknown",
      lastName: "Unknown",
      avatar: "",
      hasGPSSignal: false,
      role: Role.fromMap({"id": "", "title": ""}),
      rating: 0,
      onlineUpdatedAt: 0,
    );
  }
}

class Role {
  Role({
    this.id,
    this.title,
  });

  final String? id;
  final String? title;

  factory Role.fromMap(Map<String, dynamic> json) => Role(
        id: json["id"] as String?,
        title: json["title"] as String?,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
      };
}
