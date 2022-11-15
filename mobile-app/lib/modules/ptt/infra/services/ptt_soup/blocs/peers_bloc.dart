import 'package:collection/collection.dart';
import 'package:mediasoup_client_flutter/mediasoup_client_flutter.dart';
import 'package:rxdart/rxdart.dart';

import '../enitity/peer.dart';

typedef PeerMap = Map<String, Peer>;

class PeersBloc {
  final PeerMap peerMap = {};
  late final _ctrl = BehaviorSubject<PeerMap>.seeded(peerMap);
  Stream<PeerMap> get outStream => _ctrl.stream;

  void refresh() {
    _ctrl.add(peerMap);
  }

  Peer _getPeerFromMap(Map map) => Peer.fromMap(map);
  Peer? _getPeerById(String peerId) => peerMap[peerId]!;
  void _setPeerById(String peerId, Peer peer) => peerMap[peerId] = peer;

  void remove(String peerId) {
    // peerMap.removeWhere((key, value) => value.id == vo.id);
    peerMap.remove(peerId);
    refresh();
  }

  void addConsumer({
    required Consumer consumer,
    // required String peerId,
  }) {
    final String peerId = consumer.peerId!;
    final Peer peer = _getPeerById(peerId)!;
    _setPeerById(peerId, peer.copyWith(audio: consumer));
  }

  Consumer? removeConsumer(String consumerId) {
    // final Peer? peer = _getPeerById(peerId);
    final Peer? peer = peerMap.values.firstWhereOrNull((p) => p.audio?.id == consumerId);
    if (peer == null) return null;
    final Consumer? consumer = peer.audio;
    if (consumer != null) {
      consumer.close();
      _setPeerById(peer.id, peer.removeAudio());
    }
    return consumer;
  }

  void pauseConsumer(String consumerId) {
    // final Peer? peer = _getPeerById(peerId);
    final Peer? peer = peerMap.values.firstWhereOrNull((p) => p.audio?.id == consumerId);
    if (peer == null) return;
    final Consumer? consumer = peer.audio;
    if (consumer != null) {
      consumer.close();
      _setPeerById(peer.id, peer.copyWith(audio: peer.audio!.pauseCopy()));
    }
  }

  void resumeConsumer(String consumerId) {
    // final Peer? peer = _getPeerById(peerId);
    final Peer? peer = peerMap.values.firstWhereOrNull((p) => p.audio?.id == consumerId);
    if (peer == null) return;
    final Consumer? consumer = peer.audio;
    if (consumer != null) {
      consumer.close();
      _setPeerById(peer.id, peer.copyWith(audio: peer.audio!.resumeCopy()));
    }
  }

  Peer add(Map map) {
    final Peer peer = _getPeerFromMap(map);
    peerMap[peer.id] = peer;
    refresh();
    return peer;
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
