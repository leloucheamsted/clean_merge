import 'package:rxdart/rxdart.dart';

typedef PeerMap = Map<String, PeerVo>;

class PeersBloc {
  final PeerMap peerMap = {};
  late final _ctrl = BehaviorSubject<PeerMap>.seeded(peerMap);
  Stream<PeerMap> get outStream => _ctrl.stream;

  void refresh() {
    _ctrl.add(peerMap);
  }

  void remove(PeerVo vo) {
    // peerMap.removeWhere((key, value) => value.id == vo.id);
    peerMap.remove(vo.id);
    refresh();
  }

  void add(PeerVo vo) {
    peerMap[vo.id] = vo;
    refresh();
  }

  void removeAll() {
    peerMap.clear();
    refresh();
  }

  void dipose() {
    peerMap.clear();
    _ctrl.close();
  }
}

class PeerVo {
  final String id;
  PeerVo({
    required this.id,
  });

  PeerVo copyWith({
    String? id,
  }) {
    return PeerVo(
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
    };
  }

  factory PeerVo.fromMap(Map<String, dynamic> map) {
    return PeerVo(
      id: map['id'] ?? '',
    );
  }

  @override
  String toString() => 'PeerVo(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PeerVo && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
