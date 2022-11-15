import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tello_social_app/modules/chat/domain/entities/group_message.entity.dart';
import 'package:tello_social_app/modules/common/widgets.dart';
import 'package:tello_social_app/modules/core/extensions/duration.extension.dart';
import 'package:tello_social_app/modules/core/services/implementations/audioplayer/manager/audio_player_manager.dart';
import 'package:tello_social_app/modules/core/services/implementations/audioplayer/manager/audio_player_manger_child.dart';
import 'package:tello_social_app/modules/core/services/interfaces/i_audio_player.dart';

class MessageListItem extends StatefulWidget {
  final GroupMessageEntity entity;
  const MessageListItem({Key? key, required this.entity}) : super(key: key);

  @override
  State<MessageListItem> createState() => _MessageListItemState();
}

class _MessageListItemState extends State<MessageListItem> {
  // final AudioPlayerManagerChild _audioPlayerManagerChild = Modular.get<AudioPlayerManager>().createChild(uniqueId, src)

  AudioPlayerManagerChild? _audioPlayerManagerChild;

  AudioPlayerManagerChild get audioPlayerManagerChild {
    // return _audioPlayerManagerChild;
    // _audioPlayerManagerChild ??=Modular.get<AudioPlayerManager>().createChild(widget.entity.id, widget.entity.audioFile.url);
    if (_audioPlayerManagerChild == null) {
      final AudioPlayerManager mngr = Modular.get<AudioPlayerManager>();
      _audioPlayerManagerChild = mngr.createChild(widget.entity.id, widget.entity.audioFile.url);
      // _audioPlayerManagerChild =Modular.get<AudioPlayerManager>().createChild(widget.entity.id, widget.entity.audioFile.url);
      // _audioPlayerManagerChild = Modular.get<AudioPlayerManager>();
      // _audioPlayerManager!.setUrlSource(widget.entity.audioFile.url);
      // _audioPlayer!.setFileSource(widget.entity.audioFile.url);
    }
    return _audioPlayerManagerChild!;
  }

  @override
  void didUpdateWidget(covariant MessageListItem oldWidget) {
    // if (widget.value != oldWidget.value) {
    // final AudioPlayerManager mngr = Modular.get<AudioPlayerManager>();
    // _audioPlayerManagerChild = mngr.ge

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // _audioPlayerManagerChild?.stop();
    _audioPlayerManagerChild?.dispose();
    // _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return Text("kro");
    return ListTile(
      leading: ImgLogoWidget(
        imgSrc: widget.entity.contact!.avatar,
        borderColor: Colors.green,
        borderWidth: 4,
      ),
      title: Text(widget.entity.contact!.displayName ?? "nonName"),
      subtitle: _buildDuration(),
      trailing: _buildPlayPauseBtn(),
    );
  }

  Widget _buildDuration() {
    return StreamBuilder<Duration>(
        stream: audioPlayerManagerChild.positionStream,
        builder: (context, snapshot) {
          final Duration? dur = snapshot.data;
          if (dur == null) {
            return _buildDuration2(Duration(milliseconds: widget.entity.audioFile.duratonMs));
          } else {
            return _buildDuration2(dur);
          }
        });
  }

  Widget _buildDuration2(Duration duration) {
    // onPlayerStateChanged
    return StreamBuilder<bool>(
        stream: audioPlayerManagerChild.isPlayingStream,
        builder: (context, snapshot) {
          final bool isPlaying = snapshot.hasData && snapshot.data == true;
          return _buildDuration3(duration, isPlaying);
        });
  }

  Widget _buildDuration3(Duration duration, bool isPlaying) {
    return Text(
      duration.toHoursMinutesSeconds(),
      style: Theme.of(context).textTheme.subtitle2?.copyWith(color: isPlaying ? Colors.green : Colors.grey.shade500),
    );
  }

  Widget _buildPlayPauseBtn() {
    // onPlayerStateChanged
    return StreamBuilder<bool>(
        stream: audioPlayerManagerChild.isPlayingStream,
        builder: (context, snapshot) {
          final bool isPlaying = snapshot.hasData && snapshot.data == true;
          return IconButton(
            onPressed: onPlayBtn,
            icon: Icon(
              isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
              size: 34,
              color: Colors.green,
            ),
          );
        });
  }

  void onPlayBtn() {
    audioPlayerManagerChild.togglePlayPause();
  }
}
