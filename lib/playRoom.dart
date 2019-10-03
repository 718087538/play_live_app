import 'package:flutter/material.dart';
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
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final FijkPlayer player = FijkPlayer();
  String playUrl = "原始url";

  @override
  void initState() {
    super.initState();
    getUrl();
    player.setDataSource(playUrl, autoPlay: true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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

  void test(String newUrl) {
    setState(() {
      playUrl = newUrl;
    });
  }

  void getUrl() async {
    String url = "rtmp://202.69.69.180:443/webcast/bshdlive-pc";
    test(url);
  }
}
