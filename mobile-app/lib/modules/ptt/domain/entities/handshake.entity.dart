class HandshakeEntity {
  final String schema;
  final String host;
  final int? port;
  final String? token;
  final String? peerId;
  final String userId;
  final String? groupId;
  final bool isBackgroundService;
  HandshakeEntity({
    required this.schema,
    required this.host,
    this.port,
    // required this.token,
    this.token,
    this.peerId,
    required this.userId,
    required this.groupId,
    required this.isBackgroundService,
  });

  Uri get uri {
    // return Uri.parse("https://letsmeet.no?peerId=1&groupId=roomTestoyevski");
    String? urlSchema = schema;
    if (schema == "ws") {
      urlSchema = "http";
    } else if (schema == "wss") {
      urlSchema = "https";
    }

    final String a = port == null ? '$urlSchema://$host' : '$urlSchema://$host:$port';

    final Map<String, dynamic> queryMap = {
      "peerId": peerId,
      "userId": userId,
      "token": token,
      "groupId": groupId,
    };
    queryMap.removeWhere((key, value) => value == null);
    // final String b ="?peerId=$peerId&userId=$userId&groupId=${groupId ?? ''}&backgroundService=$isBackgroundService&token=$token";
    return Uri.parse(a).replace(queryParameters: queryMap);
  }

  @Deprecated("use get uri")
  String get url {
    String? urlSchema = schema;
    if (schema == "ws") {
      urlSchema = "http";
    } else if (schema == "wss") {
      urlSchema = "https";
    }

    final String a = port == null ? '$urlSchema://$host' : '$urlSchema://$host:$port';
    final String b =
        "?peerId=$peerId&userId=$userId&groupId=${groupId ?? ''}&backgroundService=$isBackgroundService&token=$token";
    return "$a$b";
  }

  HandshakeEntity copyWith({
    String? schema,
    String? host,
    int? port,
    String? token,
    String? peerId,
    String? userId,
    String? groupId,
    bool? isBackgroundService,
  }) {
    return HandshakeEntity(
      schema: schema ?? this.schema,
      host: host ?? this.host,
      port: port ?? this.port,
      token: token ?? this.token,
      peerId: peerId ?? this.peerId,
      userId: userId ?? this.userId,
      groupId: groupId ?? this.groupId,
      isBackgroundService: isBackgroundService ?? this.isBackgroundService,
    );
  }
}
