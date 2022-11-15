import 'dart:async';
import 'dart:developer';
import 'dart:io';

// import 'package:flutter_webrtc/enums.dart';
// import 'package:flutter_webrtc/media_recorder.dart';

import 'package:tello_social_app/modules/ptt/infra/services/interfaces/i_metadata_retriever.dart';
import 'package:tello_social_app/modules/ptt/infra/services/interfaces/i_recorder.dart';
import 'package:uuid/uuid.dart';

// import '../models/local_audio_message.dart';

/// Used for transmissions recording. The instance of this class is created only once in RTCService.init()
class TransmissionRecording {
  String? appDir;
  File? recordingFile;
  // Completer? prevRecordingComplete;

  bool _isRecording = false;

  bool get isRecording => _isRecording;

  // late MediaRecorder _mediaRecorder;
  // final _record = Record();

  final IMetaDataRetriever metaDataRetriever;
  final IRecorder localRecorder;
  final IRecorder webRtcRecorder;
  TransmissionRecording({
    this.appDir,
    required this.metaDataRetriever,
    required this.localRecorder,
    required this.webRtcRecorder,
  });

  /// Make sure you await for stop() before calling start(), since common resources are used for the recording
  Future<void> start({Stopwatch? stopwatch, bool isOffline = false}) async {
    _isRecording = true;
    recordingFile = File('$appDir/rec-${const Uuid().v1()}.m4a');
    try {
      log("Transmission start(): starting recording to file path -> ${recordingFile!.path}");
      if (isOffline) {
        // AudioEncoder encoder = AudioEncoder.opus;
        AudioEncoderModel encoderModel = AudioEncoderModel.opus;
        //TODO: inject without dependening on external settings config _ALL
        /*if (Platform.isAndroid) {
          if (SettingsController.to.osSDKInt! < 30) {
            encoder = AudioEncoder.amrNb;
          }
        }*/

        await localRecorder.start(
          recordingFile!.path,
          bitrate: 1024 * 8,
          samplingRate: 8000,
          audioEncoderModel: encoderModel,
        );
      } else {
        // _mediaRecorder = MediaRecorder();
        String mimeType = "audio/opus";
        /*if (Platform.isAndroid) {
          if (SettingsController.to.osSDKInt! < 30) {
            mimeType = "audio/mp4a-latm";
          }
        }*/
        await webRtcRecorder.start(
          recordingFile!.path,
          // audioChannel: RecorderAudioChannel.INPUT,
          audioChannelModel: AudioChannelModel.input,
          bitrate: 8,
          mimeType: mimeType,
        );
      }

      // RTCService().prevRecordingComplete = Completer();
    } catch (e, s) {
      _log("Transmission start(): FAILED _mediaRecorder Reason $e", stackTrace: s);
    }
  }

  void _log(String msg, {StackTrace? stackTrace}) {
    log(msg);
  }

  /// Make sure you await for stop() before calling start(), since common resources are used for the recording
  Future<void> stop({bool isOffline = false}) async {
    _log("Transmission stop(): stopping recording  ${recordingFile!.path}");
    _isRecording = false;
    if (isOffline) {
      await localRecorder.stop();
      //TODO: should work without it, remove if no problems with offline recording found
      // await Record.close();
    } else {
      await webRtcRecorder.stop();
    }
    _log("Transmission stop(): recording stopped");
    return;

    // final targetFile = File(recordingFile.path);
    // final targetFileSize = await targetFile.length();

    try {
      /*if (message == null || !targetFile.existsSync() || targetFileSize == 0) {
        return;
      }

      // final MetaDataModel metadata = await MetadataRetriever.fromFile(recordingFile);
      final MetaDataModel metadata = await metaDataRetriever.fromFile(recordingFile);

      final String mimeType = metadata.mimeType!;
      final int duration = metadata.duration!;
      final bool isNeedTranscode = mimeType != "audio/opus";

      _log("Transmission stop(): recording duration: $duration");

      

      //TODO: inject without dependency
      // if (duration < AppSettings().audioMessageRetainThresholdMs) {
        // return targetFile.deleteSync();
      // }

      final owner = Session.user!..isOnline(HomeController.to.isOnline); //todo: handle if to can be null

      // StatisticsService().totalPTTRecordingSent += targetFileSize;
      _log("Transmission stop(): fileSize ==> $targetFileSize");

      //TODO: [TELLO-4508] device to mutate original object or just clone (updateWith or copyWith) _ALL
      message.updateWith(
        mimeType: mimeType,
        owner: owner,
        filePath: recordingFile.path,
        fileDurationMs: duration,
        createdAtTimestamp: message.createdAt!.millisecondsSinceEpoch,
        // createdAtTimestamp: dateTimeToSeconds(message.createdAt!),
        groupId: HomeController.to.activeGroup!.id, //handle activeGroup null case _ALL
        isNeedTranscode: isNeedTranscode,
      );
      */

      /*if (HomeController.to.allGroupsBroadcast) {
        message.groupIds.addAll(HomeController.to.groups.map((g) => g.id!));
      } else {
        message.groupId = HomeController.to.activeGroup?.id;
      }*/

      // MessageUploadService.to.addAndProcess(message);
    } catch (e, s) {
      _log(
        'Transmission stop(): error while stopping recording: $e',
        stackTrace: s,
      );
    } finally {
      //TODO: fix  Unhandled Exception: Null check operator used on a null value _ALL
      // RTCService().prevRecordingComplete!.complete();
      // RTCService().prevRecordingComplete?.complete();
    }
  }
}
