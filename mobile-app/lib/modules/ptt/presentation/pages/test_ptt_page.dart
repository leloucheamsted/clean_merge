import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tello_social_app/modules/common/constants/layout_constants.dart';
import 'package:tello_social_app/modules/common/widget/buttons/simple_button.dart';
import 'package:tello_social_app/modules/ptt/infra/services/ptt_soup/enitity/peer.dart';
import 'package:tello_social_app/modules/ptt/presentation/ui/media_device_list.dart';
// import 'package:tello_social_app/modules/ptt/infra/services/ptt/ptt_service.dart.all';

import '../blocs/test_ptt_bloc.dart';

class TestPttPage extends StatefulWidget {
  const TestPttPage({Key? key}) : super(key: key);

  @override
  State<TestPttPage> createState() => _TestPttPageState();
}

class _TestPttPageState extends State<TestPttPage> {
  late final TestPttBloc bloc = Modular.get();
  // late final TestPttBloc bloc = TestPttBloc();
  late final ScrollController _logScroll = ScrollController();
  late StreamSubscription _logStreamSub;
  @override
  void initState() {
    _logStreamSub = bloc.outLog.listen((event) {
      if (_logScroll.hasClients) {
        _logScroll.jumpTo(_logScroll.position.maxScrollExtent);
      }
    });
    // _logScroll.jumpTo(_logScroll.position.maxScrollExtent);
    super.initState();
  }

  @override
  void dispose() {
    _logStreamSub.cancel();
    _logScroll.dispose();
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TestPttPage"),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SimpleButton(
              onTap: _onConnectBtn,
              content: "Connect",
            ),
            /*const SizedBox(height: LayoutConstants.spaceL),
            SimpleButton(
              onTap: bloc.enableMic,
              content: "enableMic",
            ),*/
            const SizedBox(height: LayoutConstants.spaceL),
            SizedBox(height: 150, child: _buildPeers()),
            SizedBox(height: 100, child: _buildMediaDevices()),
            SizedBox(height: 200, child: _buildLogs()),
          ],
        ),
      ),
    );
  }

  Widget _buildLogs() {
    return StreamBuilder<String>(
      stream: bloc.outLog,
      builder: ((context, snapshot) {
        if (snapshot.data == null) {
          return Text(
            "no logs",
            textAlign: TextAlign.end,
            maxLines: 8,
          );
        }

        return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            controller: _logScroll,
            child: Text(
              bloc.allLogs.join("\n"),
              softWrap: true,
              // textAlign: TextAlign.end,
            ));
      }),
    );
  }

  Widget _buildMediaDevices() {
    return StreamBuilder(
      stream: bloc.mediaDevicesBloc.outAudioDevices,
      builder: ((context, snapshot) {
        if (snapshot.data == null) {
          return Text("empty devices");
        }
        return MediaDeviceList(list: snapshot.data!);
      }),
    );
  }

  Widget _buildPeers() {
    return StreamBuilder(
      stream: bloc.peersBloc.outStream,
      builder: ((context, snapshot) {
        final Map<String, Peer>? map = snapshot.data;
        if (map == null) {
          return Text("empty peers");
        }
        final List<Peer> list = map.values.toList();
        return ListView.builder(
          itemCount: list.length,
          primary: false,
          itemBuilder: ((context, index) {
            return Text(list[index].displayName);
          }),
        );
      }),
    );
  }

  void _onConnectBtn() {
    // bloc.init();
    bloc.connect();
  }
}
