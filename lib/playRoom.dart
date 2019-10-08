import 'package:flutter/material.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayRoom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('直播间'),
        ),
        body: new PlayPage());
  }
}

class PlayPage extends StatefulWidget {
  _PlayPage createState() => _PlayPage();
}

class _PlayPage extends State<PlayPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 500.0,
        height: 550.0,
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            VideoScreen(),
            msgList(),
            sendMsg(),
          ],
        ));
  }
}

//发送消息类
class sendMsg extends StatefulWidget {
  _sendMsg createState() => _sendMsg();
}

class _sendMsg extends State<sendMsg> {
  @override
  Widget build(BuildContext context) {
    return Container(
          width: 750.0,
          margin: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Text("请输入您的留言内容"
              ),
              Expanded(
                child: Text("发送"),
              ),
            ],
          ),
    );
  }
}


//消息列表类
class msgList extends StatefulWidget {
  _msgList createState() => _msgList();
}

class _msgList extends State<msgList> {
  List list = [
    {'name': "kkk", 'msg': "我是留言内容呢", 'uid': "125535352"},
    {'name': "222名", 'msg': "2222", 'uid': "125535352"},
    {'name': "33333名", 'msg': "333333", 'uid': "125535352"},
    {'name': "44444名", 'msg': "4444444", 'uid': "125535352"},
    {'name': "44444名", 'msg': "444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444", 'uid': "125535352"},
    {'name': "44444名", 'msg': "4444444", 'uid': "125535352"},
    {'name': "44444名", 'msg': "4444444", 'uid': "125535352"},
    {'name': "44444名", 'msg': "4444444", 'uid': "125535352"},
    {'name': "44444名", 'msg': "4444444", 'uid': "125535352"},
    {'name': "44444名", 'msg': "4444444", 'uid': "125535352"},
    {'name': "44444名", 'msg': "4444444", 'uid': "125535352"},
    {'name': "44444名", 'msg': "4444444", 'uid': "125535352"},
    {'name': "44444名", 'msg': "4444444", 'uid': "125535352"},
    {'name': "44444名", 'msg': "4444444", 'uid': "125535352"},
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(

      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _list(list, index, context);
        },
      ),
    );
  }
}

Widget _list(list, int index, context) {
  return InkWell(
    child: Container(
        width: 750.0,
        margin: EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            Text(list[index]["name"],
              style: TextStyle(
                color: Colors.redAccent,
              ),
            ),
            Expanded(
              child: Text(list[index]["msg"]),
            ),
          ],
        )),
//      child: Text(list[index]["title"]),
  );
}

//视频播放类
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
      width: 500.0,
      height: 240.0,
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
