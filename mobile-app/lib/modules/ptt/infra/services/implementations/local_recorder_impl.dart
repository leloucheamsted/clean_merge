import 'package:record/record.dart';
import 'package:tello_social_app/modules/ptt/infra/services/interfaces/i_recorder.dart';

class LocalRecorderImpl implements IRecorder {
  final _plugin = Record();

  @override
  Future<void> start(
    String path, {
    AudioChannelModel? audioChannelModel,
    int bitrate = 1024 * 8,
    int samplingRate = 8000,
    String? mimeType,
    AudioEncoderModel? audioEncoderModel,
  }) {
    return _plugin.start(
        path: path, bitRate: bitrate, samplingRate: samplingRate, encoder: _mapEncoder(audioEncoderModel));
  }

  AudioEncoder _mapEncoder(AudioEncoderModel? encoderModel) {
    const AudioEncoder defaultValue = AudioEncoder.opus;
    if (encoderModel == null) return defaultValue;
    return AudioEncoder.values.firstWhere(
      (element) => element.name == encoderModel.name,
      orElse: () => defaultValue,
    );
  }

  @override
  Future stop() => _plugin.stop();

  @override
  Future<bool> isRecording() => _plugin.isRecording();
}
