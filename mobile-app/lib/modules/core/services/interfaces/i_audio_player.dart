abstract class IAudioPlayer<T> {
  Future<T> setFileSource(String path);
  Future<T> setUrlSource(String path);
  void dispose();
  Future<void> play();
  Future<void> pause();
  Future<void> resume();
  Future<void> stop();
  Future<void> togglePlayPause();
  Future<void> seek(Duration duration);
  Future<Duration?> get duration;
  Stream<AudioPlayerState>? get playerStateStream;
  Stream<Duration>? get positionStream;
  bool get isPlaying;
  Stream<bool> get isPlayingStream;
}

enum AudioPlayerState {
  /// The player has not loaded an [AudioSource].
  idle,

  /// The player is loading an [AudioSource].
  loading,

  /// The player is buffering audio and unable to play.
  buffering,

  /// The player is has enough audio buffered and is able to play.
  ready,

  /// The player has reached the end of the audio.
  completed,
}
