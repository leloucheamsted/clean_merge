class TransportResponseEntity {
  final dynamic peerId;
  final dynamic id;
  final dynamic iceParameters;
  final dynamic iceCandidates;
  final dynamic dtlsParameters;
  final dynamic sctpParameters;
  TransportResponseEntity({
    required this.peerId,
    required this.id,
    required this.iceParameters,
    required this.iceCandidates,
    required this.dtlsParameters,
    required this.sctpParameters,
  });

  Map<String, dynamic> toMap() {
    return {
      'peerId': peerId,
      'id': id,
      'iceParameters': iceParameters,
      'iceCandidates': iceCandidates,
      'dtlsParameters': dtlsParameters,
      'sctpParameters': sctpParameters,
    };
  }

  factory TransportResponseEntity.fromMap(Map<String, dynamic> map) {
    return TransportResponseEntity(
      peerId: map['peerId'],
      id: map['id'],
      iceParameters: map['iceParameters'],
      iceCandidates: map['iceCandidates'],
      dtlsParameters: map['dtlsParameters'],
      sctpParameters: map['sctpParameters'],
    );
  }
}
