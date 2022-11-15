// import 'package:advanced_audio_manager/advanced_audio_manager.dart';
import 'package:flutter_audio_manager/flutter_audio_manager.dart';
import 'package:rxdart/subjects.dart';
import 'package:tello_social_app/modules/ptt/infra/services/interfaces/i_audio_device_manager.dart';

class AudioManagerImpl implements IAudioDeviceManager {
  final _ctrlInput = BehaviorSubject<AudioDevice>();
  AudioManagerImpl() {
    FlutterAudioManager.setListener(_onChanged);
  }
  void _onChanged() async {
    final device = await getCurrentOutput();
    if (!_ctrlInput.isClosed) {
      _ctrlInput.add(device);
    }
  }

  @override
  Future<AudioDevice> getCurrentOutput() async {
    final res = await FlutterAudioManager.getCurrentOutput();
    return _mapEntity(res);
  }

  AudioDevice _mapEntity(AudioInput e) => AudioDevice(
        name: e.name ?? "noname",
        portIndex: e.port.index,
        portName: e.port.name,
      );

  @override
  Future<List<AudioDevice>> getInputs() async {
    final list = await FlutterAudioManager.getAvailableInputs();
    return list.map(_mapEntity).toList();
  }

  @override
  Stream<AudioDevice> get onCurrentChanged => _ctrlInput.stream;

  @override
  void dispose() {
    _ctrlInput.close();
  }
}
