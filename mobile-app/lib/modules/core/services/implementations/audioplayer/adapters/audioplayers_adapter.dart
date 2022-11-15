import 'package:audioplayers/audioplayers.dart';
import 'package:tello_social_app/modules/core/services/interfaces/i_audio_player.dart';

class AudioPlayersAdapter implements IAudioPlayer<void> {
  late final AudioPlayer _audioPlayer = AudioPlayer();

  late Source _source;

  AudioPlayersAdapter();

  @override
  Future<void> pause() {
    return _audioPlayer.pause();
  }

  @override
  Future<void> play() {
    return _audioPlayer.play(_source);
    // return _audioPlayer.play(UrlSource(path));
  }

  @override
  Future<void> resume() {
    return _audioPlayer.resume();
  }

  @override
  Future<void> stop() {
    return _audioPlayer.stop();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
  }

  @override
  Future<void> setFileSource(String path) {
    _source = DeviceFileSource(path);
    return _audioPlayer.setSource(_source);
  }

  @override
  Future<void> setUrlSource(String path) {
    _source = UrlSource(path);
    return _audioPlayer.setSource(_source);
  }

  @override
  Future<void> togglePlayPause() {
    return isPlaying ? _audioPlayer.pause() : _audioPlayer.resume();
  }

  @override
  bool get isPlaying => _audioPlayer.state == PlayerState.playing;

  @override
  Future<void> seek(Duration duration) {
    return _audioPlayer.seek(duration);
  }

  @override
  Future<Duration?> get duration => _audioPlayer.getDuration();

  @override
  Stream<AudioPlayerState>? get playerStateStream => null;

  @override
  Stream<Duration>? get positionStream => _audioPlayer.onPositionChanged;

  @override
  Stream<bool> get isPlayingStream => _audioPlayer.onPlayerStateChanged.map((event) => event == PlayerState.playing);
}
