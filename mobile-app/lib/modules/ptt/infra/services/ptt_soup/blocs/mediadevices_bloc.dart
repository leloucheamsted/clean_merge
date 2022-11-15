import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:rxdart/rxdart.dart';

class MediaDevicesBloc {
  final List<MediaDeviceInfo> _audioInputs = [];
  final List<MediaDeviceInfo> _audioOutputs = [];

  final _ctrlAudioDevices = BehaviorSubject<List<MediaDeviceInfo>>.seeded([]);
  Stream<List<MediaDeviceInfo>> get outAudioDevices => _ctrlAudioDevices.stream;

  // MediaDeviceInfo? _selectedAudioInput;
  // MediaDeviceInfo? _selectedAudioOutput;
  // MediaDeviceInfo? get selectedAudioInput => _selectedAudioInput;
  // MediaDeviceInfo? get selectedAudioOutput => _selectedAudioOutput;

  final _ctrlAudioInput = BehaviorSubject<MediaDeviceInfo?>.seeded(null);
  Stream<MediaDeviceInfo?> get outAudioInput => _ctrlAudioInput.stream;
  MediaDeviceInfo? get audioInput => _ctrlAudioInput.value;

  final _ctrlAudioOutput = BehaviorSubject<MediaDeviceInfo?>.seeded(null);
  Stream<MediaDeviceInfo?> get outAudioOutput => _ctrlAudioOutput.stream;
  MediaDeviceInfo? get audioOutput => _ctrlAudioOutput.value;

  Function(MediaDeviceInfo) get changeAudioInput => _ctrlAudioInput.sink.add;
  Function(MediaDeviceInfo) get changeAudioOutput => _ctrlAudioOutput.sink.add;

  void actionLoad() async {
    final List<MediaDeviceInfo> devices = await navigator.mediaDevices.enumerateDevices();
    _ctrlAudioDevices.add(devices);
    devices.forEach((device) {
      switch (device.kind) {
        case 'audioinput':
          _audioInputs.add(device);
          break;
        case 'audiooutput':
          _audioOutputs.add(device);
          break;
        default:
          break;
      }
    });
    if (_audioInputs.isNotEmpty) {
      changeAudioInput(_audioInputs.first);
    }
    if (_audioOutputs.isNotEmpty) {
      changeAudioOutput(_audioOutputs.first);
    }
  }

  void dipose() {
    _ctrlAudioDevices.close();
    _ctrlAudioInput.close();
    _ctrlAudioOutput.close();
  }
}
