class OtpToken {
  final String token;
  final String code;
  OtpToken({
    required this.token,
    required this.code,
  });

  OtpToken copyWith({
    String? token,
    String? code,
  }) {
    return OtpToken(
      token: token ?? this.token,
      code: code ?? this.code,
    );
  }

  factory OtpToken.fromMap(Map<String, dynamic> map) {
    return OtpToken(
      token: map['otpToken'],
      code: map['otpCode'],
    );
  }
  @override
  String toString() => 'OtpToken(token: $token, code: $code)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OtpToken && other.token == token && other.code == code;
  }

  @override
  int get hashCode => token.hashCode ^ code.hashCode;
}
