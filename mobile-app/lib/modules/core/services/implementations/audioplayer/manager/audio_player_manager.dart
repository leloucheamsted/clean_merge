// import 'dart:async';

import 'dart:async';

import 'package:tello_social_app/modules/core/services/interfaces/i_audio_player.dart';

import 'audio_player_manger_child.dart';

// class AudioPlayerManager implements IAudioPlayer { //causes servce locator stackoverflow
class AudioPlayerManager {
  final IAudioPlayer _audioPlayer;
  AudioPlayerManager(this._audioPlayer) {
    print("AudioPlayerManager created");

    _audioPlayer.isPlayingStream.listen(print);
    /*_audioPlayer.isPlayingStream.listen((event) {
      if (!_playingCtrl.isClosed) {
        _playingCtrl.add(event);
      }
    });*/
  }

  // final StreamController<String> _activeKeyCtrl = StreamController<String>();
  // final StreamController<AudioPlayerState> _stateCtrl = StreamController<AudioPlayerState>.broadcast();
  // final StreamController<bool> _playingCtrl = StreamController<bool>.broadcast();

  final Map<String, String> _childMap = {};

  String? _activeChildId;
  String? get activeChildId => _activeChildId;

  Future<void> setActiveChild(String id) async {
    if (_activeChildId == id) {
      return Future.value(null);
    }
    if (isPlaying) {
      await _audioPlayer.stop();
    }
    _activeChildId = id;
    final String? source = _childMap[id];
    if (source == null) {
      throw Exception("Child not found");
    }
    setUrlSource(source);
    return play();
  }

  AudioPlayerManagerChild createChild(String uniqueId, String src) {
    final bool b = _childMap.containsKey(uniqueId);
    /*if (b) {
      throw Exception("child already exists with this key $uniqueId");
    }*/
    final AudioPlayerManagerChild child = AudioPlayerManagerChild(this, id: uniqueId);
    _childMap.putIfAbsent(uniqueId, () => src);
    return child;
  }

  void removeChild(String uniqueId) {
    _childMap.remove(uniqueId);
  }

  void clearChilds() {
    _childMap.clear();
    _activeChildId = null;
  }

  @override
  void dispose() {
    // _activeKeyCtrl.close();
    // _stateCtrl.close();
    _audioPlayer.dispose();
  }

  @override
  Future<Duration?> get duration => _audioPlayer.duration;

  @override
  bool get isPlaying => _audioPlayer.isPlaying;

  @override
  Stream<bool> get isPlayingStream => _audioPlayer.isPlayingStream;

  @override
  Future<void> pause() {
    return _audioPlayer.pause();
  }

  @override
  Future<void> play() {
    return _audioPlayer.play();
  }

  @override
  Stream<Duration>? get positionStream => _audioPlayer.positionStream;

  @override
  Future<void> resume() {
    return _audioPlayer.resume();
  }

  @override
  Future<void> seek(Duration duration) {
    return _audioPlayer.seek(duration);
  }

  @override
  Future setFileSource(String path) {
    return _audioPlayer.setFileSource(path);
  }

  @override
  Future setUrlSource(String path) {
    return _audioPlayer.setUrlSource(path);
  }

  @override
  Future<void> stop() {
    return _audioPlayer.stop();
  }

  @override
  Future<void> togglePlayPause() {
    return _audioPlayer.togglePlayPause();
  }

  @override
  Stream<AudioPlayerState>? get playerStateStream => _audioPlayer.playerStateStream;
}
