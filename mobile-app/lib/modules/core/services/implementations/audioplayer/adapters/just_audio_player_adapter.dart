import 'package:just_audio/just_audio.dart';
import 'package:tello_social_app/modules/core/services/interfaces/i_audio_player.dart';

class JustAudioPlayerAdapter implements IAudioPlayer<Duration?> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Duration? totalDuration;
  @override
  void dispose() {
    _audioPlayer.dispose();
  }

  @override
  Future<void> pause() {
    return _audioPlayer.pause();
  }

  @override
  Future<void> play() => _audioPlayer.play();
  @override
  Future<void> resume() => _audioPlayer.play();

  @override
  Future<void> stop() => _audioPlayer.stop();

  @override
  Future<Duration?> setFileSource(String path) {
    return _audioPlayer.setFilePath(path);
  }

  @override
  Future<Duration?> setUrlSource(String path) {
    return _audioPlayer.setUrl(path);
  }

  @override
  bool get isPlaying => _audioPlayer.playing;

  @override
  Future<void> togglePlayPause() {
    return isPlaying ? pause() : play();
  }

  @override
  Future<void> seek(Duration duration) {
    return _audioPlayer.seek(duration);
  }

  @override
  Future<Duration?> get duration => Future.value(_audioPlayer.duration);

  @override
  Stream<AudioPlayerState>? get playerStateStream => _audioPlayer.playerStateStream.map(_mapPlayerState);

  AudioPlayerState _mapPlayerState(PlayerState state) {
    late AudioPlayerState audioPlayerState;
    final ProcessingState processingState = state.processingState;
    switch (processingState) {
      case ProcessingState.idle:
        audioPlayerState = AudioPlayerState.idle;
        break;
      case ProcessingState.buffering:
        audioPlayerState = AudioPlayerState.buffering;
        break;
      case ProcessingState.loading:
        audioPlayerState = AudioPlayerState.loading;
        break;
      case ProcessingState.ready:
        audioPlayerState = AudioPlayerState.ready;
        break;
      case ProcessingState.completed:
        audioPlayerState = AudioPlayerState.completed;
        break;
      default:
        audioPlayerState = AudioPlayerState.idle;
    }
    return audioPlayerState;
  }

  Duration _mapDurationLeft(Duration progress) {
    Duration? total = _audioPlayer.duration;
    return total == null ? progress : total - progress;
  }

  @override
  // Stream<Duration>? get positionStream => _audioPlayer.positionStream;
  Stream<Duration>? get positionStream => _audioPlayer.positionStream.map(_mapDurationLeft);

  @override
  Stream<bool> get isPlayingStream => _audioPlayer.playingStream;
}
