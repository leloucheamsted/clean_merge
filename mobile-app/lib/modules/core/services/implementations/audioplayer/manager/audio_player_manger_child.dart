import 'package:tello_social_app/modules/core/services/interfaces/i_audio_player.dart';

import 'audio_player_manager.dart';

class AudioPlayerManagerChild implements IAudioPlayer {
  final String id;
  final AudioPlayerManager _manager;

  AudioPlayerManagerChild(this._manager, {required this.id});

  @override
  void dispose() {
    // _manager.dispose();
    stop();
    _manager.removeChild(id);
  }

  @override
  Future<Duration?> get duration => _manager.duration;

  bool get isActive => _manager.activeChildId == id;

  @override
  bool get isPlaying => _manager.isPlaying && isActive;

  @override
  Stream<bool> get isPlayingStream => _manager.isPlayingStream.where((st) => isActive);

  @override
  Future<void> pause() {
    if (isActive) {
      return _manager.pause();
    }
    return Future.value(null);
  }

  @override
  Future<void> play() {
    if (isActive) {
      return _manager.play();
    }
    return Future.value(null);
  }

  @override
  Stream<AudioPlayerState>? get playerStateStream => _manager.playerStateStream?.where((event) => isActive);

  @override
  Stream<Duration>? get positionStream => _manager.positionStream?.where((event) => isActive);

  @override
  Future<void> resume() {
    if (isActive) {
      return _manager.resume();
    }
    return Future.value(null);
  }

  @override
  Future<void> seek(Duration duration) {
    if (isActive) {
      return _manager.seek(duration);
    }
    return Future.value(null);
  }

  @override
  Future setFileSource(String path) {
    if (isActive) {
      return _manager.setFileSource(path);
    }
    return Future.value(null);
  }

  @override
  Future setUrlSource(String path) {
    if (isActive) {
      return _manager.setUrlSource(path);
    }
    return Future.value(null);
  }

  @override
  Future<void> stop() {
    if (isActive) {
      return _manager.stop();
    }
    return Future.value(null);
  }

  @override
  Future<void> togglePlayPause() {
    if (isActive) {
      return _manager.togglePlayPause();
    } else {
      _manager.setActiveChild(id);
    }
    return Future.value(null);
  }
}
