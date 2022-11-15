import 'dart:convert';

enum AudioFileMimeType {
  opus("audio/opus"),
  mp4a("audio/mp4a-latm");

  const AudioFileMimeType(this.value);
  final String value;
}

class AudioFileEntity {
  final int duratonMs;
  final String url;
  final AudioFileMimeType mimeType;
  // final bool isVanishable; //clear after listen

  AudioFileEntity({
    required this.duratonMs,
    required this.url,
    required this.mimeType,
  });

  AudioFileEntity copyWith({
    int? duratonMs,
    String? url,
    AudioFileMimeType? mimeType,
  }) {
    return AudioFileEntity(
      duratonMs: duratonMs ?? this.duratonMs,
      url: url ?? this.url,
      mimeType: mimeType ?? this.mimeType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'duraton_ms': duratonMs,
      'url': url,
      'mime_type': mimeType.value,
    };
  }

  factory AudioFileEntity.fromMap(Map<String, dynamic> map) {
    return AudioFileEntity(
      duratonMs: map['duraton_ms']?.toDouble() ?? 0.0,
      url: map['url'] ?? '',
      mimeType: AudioFileMimeType.values.byName(map['mime_type']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AudioFileEntity.fromJson(String source) => AudioFileEntity.fromMap(json.decode(source));

  @override
  String toString() => 'AudioFileEntity(duratonMs: $duratonMs, url: $url, mimeType: $mimeType)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AudioFileEntity && other.duratonMs == duratonMs && other.url == url && other.mimeType == mimeType;
  }

  @override
  int get hashCode => duratonMs.hashCode ^ url.hashCode ^ mimeType.hashCode;
}
