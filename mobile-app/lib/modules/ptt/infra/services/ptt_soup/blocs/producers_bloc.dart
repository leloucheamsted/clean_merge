import 'package:mediasoup_client_flutter/mediasoup_client_flutter.dart';
import 'package:rxdart/rxdart.dart';

// typedef ProducersMap = Map<String, Producer>;

class ProducersBloc {
  // final ProducersMap peerMap = {};
  Producer? _producer;
  Producer? get producer => _producer;
  late final _ctrl = BehaviorSubject<Producer?>.seeded(_producer);
  Stream<Producer?> get outStream => _ctrl.stream;

  void refresh() {
    _ctrl.add(_producer);
  }

  void remove() {
    // peerMap.removeWhere((key, value) => value.id == vo.id);
    // peerMap.remove(vo.id);
    if (_producer == null) return;
    _producer!.close();
    _producer = null;
    refresh();
  }

  void add(Producer vo) {
    _producer = vo;
    refresh();
  }

  void pause() {
    _producer = _producer!.pauseCopy();
    refresh();
  }

  void resume() {
    _producer = _producer!.resumeCopy();
    refresh();
  }

  void dipose() {
    if (_producer != null) {
      _producer!.close();
      _producer = null;
    }
    _ctrl.close();
  }
}
