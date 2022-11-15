class SignedUrlResponse {
  final String? signedUrl, publicUrl;
  final int? expiresIn;

  const SignedUrlResponse({
    this.signedUrl,
    this.publicUrl,
    this.expiresIn,
  });

  factory SignedUrlResponse.fromMap(Map<String, dynamic> map) {
    return SignedUrlResponse(
      signedUrl: map['signedUrl'] as String?,
      publicUrl: map['publicUrl'] as String?,
      expiresIn: map['expiresIn'] as int?,
    );
  }
}
