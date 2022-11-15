import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

//TODO: create interface

class SoundPoolService {
  static final SoundPoolService _singleton = SoundPoolService._();

  factory SoundPoolService() => _singleton;
  int? startPlayTime;
  int playDurationInMilliseconds = 1000;

  SoundPoolService._();

  late int _soundIdStart, _soundIdPttStart, _soundIdPttEnd, _soundIdMessageReceived, _soundIdOffline, _soundIdOnline;
  int? _startStreamId, _startPttStreamId, _endPttStreamId, _receivedMessageStreamId;
  String radioChirpFilePath = 'assets/sounds/radio_chirp.wav';
  String radioChirpEndFilePath = 'assets/sounds/radio_chirp_end.mp3';
  String messageReceivedFilePath = 'assets/sounds/message_notification.mp3';
  String offlineNotificationFilePath = 'assets/sounds/offline_notification.aac';
  String onlineNotificationFilePath = 'assets/sounds/online_notification.aac';
  Soundpool? _startPttSoundPool, _endPttSoundPool, _messageReceivedSoundPool, _onlineOfflineSoundPool;

  Future<void> init() async {
    _log('SoundPoolService init');
    try {
      _startPttSoundPool = _createSoundPool(streamType: StreamType.notification);
      _soundIdPttStart = await rootBundle.load(radioChirpFilePath).then((ByteData soundData) {
        return _startPttSoundPool!.load(soundData);
      });

      _endPttSoundPool = _createSoundPool(streamType: StreamType.notification);
      _soundIdPttEnd = await rootBundle.load(radioChirpEndFilePath).then((ByteData soundData) {
        return _endPttSoundPool!.load(soundData);
      });

      _messageReceivedSoundPool = _createSoundPool(streamType: StreamType.notification);
      _soundIdMessageReceived = await rootBundle.load(messageReceivedFilePath).then((ByteData soundData) {
        return _messageReceivedSoundPool!.load(soundData);
      });

      _onlineOfflineSoundPool = _createSoundPool(streamType: StreamType.notification);
      _soundIdOffline = await rootBundle.load(offlineNotificationFilePath).then((ByteData soundData) {
        return _onlineOfflineSoundPool!.load(soundData);
      });
      _soundIdOnline = await rootBundle.load(onlineNotificationFilePath).then((ByteData soundData) {
        return _onlineOfflineSoundPool!.load(soundData);
      });
    } catch (e, s) {
      _log("sound pool errors $e", stackTrace: s);
      // TelloLogger().e("sound pool errors $e", stackTrace: s);
    }
  }

  _log(String msg, {StackTrace? stackTrace}) {
    log(msg);
  }

  Soundpool _createSoundPool({required StreamType streamType}) {
    return Soundpool.fromOptions(options: SoundpoolOptions(streamType: streamType));
  }

  Future<void> playOfflineSound() async {
    await _onlineOfflineSoundPool?.play(_soundIdOffline);
  }

  Future<void> playOnlineSound() async {
    await _onlineOfflineSoundPool?.play(_soundIdOnline);
  }

  Future<void> playMessageReceivedSound() async {
    await stopMessageReceivedSound();
    _receivedMessageStreamId = await _messageReceivedSoundPool?.play(_soundIdMessageReceived, repeat: 5);
  }

  Future<void> stopMessageReceivedSound() async {
    if (_receivedMessageStreamId != null) {
      await _messageReceivedSoundPool?.stop(_receivedMessageStreamId!);
    }
  }

  int? _startPlayTime;

  Future<void> playRadioChirpSound() async {
    _log('playing start chirp');
    await stopRadioChirpSound();
    _startPttStreamId = await _startPttSoundPool?.play(_soundIdPttStart);
    _startPlayTime = DateTime.now().millisecondsSinceEpoch;
  }

  Future<void> stopRadioChirpSound() async {
    if (_startPttStreamId != null) {
      /*final int durationSincePlaying =
          DateTime.now().millisecondsSinceEpoch - _startPlayTime;
      if (durationSincePlaying < playDurationInMilliseconds) {
        await Future.delayed(Duration(milliseconds: playDurationInMilliseconds - durationSincePlaying));
      }*/
      await _startPttSoundPool?.stop(_startPttStreamId!);
    }
  }

  Future<void> playRadioChirpEndSound() async {
    _log('playing end chirp');
    await stopRadioChirpSound();
    _endPttStreamId = await _endPttSoundPool?.play(_soundIdPttEnd);
  }

  Future<void> stopRadioChirpEndSound() async {
    _log('stop playing end chirp');
    if (_endPttStreamId != null) {
      await _endPttSoundPool?.stop(_endPttStreamId!);
    }
  }

  Future<void> close() async {
    _endPttSoundPool?.release();
    _startPttSoundPool?.release();
    _messageReceivedSoundPool?.release();
    _onlineOfflineSoundPool?.release();
  }

  Future<void> dispose() async {
    _endPttSoundPool?.dispose();
    _startPttSoundPool?.dispose();
    _messageReceivedSoundPool?.dispose();
    _onlineOfflineSoundPool?.dispose();

    _endPttSoundPool = null;
    _startPttSoundPool = null;
    _messageReceivedSoundPool = null;
    _onlineOfflineSoundPool = null;
  }
}
