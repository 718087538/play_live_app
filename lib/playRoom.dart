import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fijkplayer/fijkplayer.dart';


class PlayRoom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            title: Text('直播间'),
          ),
          body: new VideoScreen());
  }
}

class VideoScreen extends StatefulWidget {
  String playUrl = "rtmp://202.69.69.180:443/webcast/bshdlive-pc";
  

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final FijkPlayer player = FijkPlayer();
  @override
  void initState() {
    super.initState();
    player.setDataSource(widget.playUrl, autoPlay: true).catchError((e) {
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
        child: FijkVolumeWatcher(
            watcher: null,
            showToast: true,
            child: FijkView(
              player: player,
            )),
    );
  }

  @override
  void dispose() {
    super.dispose();
    player.release();
  }
}
