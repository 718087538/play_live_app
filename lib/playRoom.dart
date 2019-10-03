import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fijkplayer/fijkplayer.dart';


class PlayRoom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    getHuanCun();
      return Scaffold(
          appBar: AppBar(
            title: Text('直播间'),
          ),
          body: new VideoScreen());
  }
}

class VideoScreen extends StatefulWidget {
  final String url;

  VideoScreen({@required this.url});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final FijkPlayer player = FijkPlayer();

  _VideoScreenState();

  @override
  void initState() {
    super.initState();
    player.setDataSource("rtmp://a-play.congraedu.cn/live/1?auth_key=1570078863-0-0-2839f78549953ad5cb00a19199b8b546", autoPlay: true).catchError((e) {
      FijkException fe = e as FijkException;
      //setState(() {
      //  errorMsg = fe.message;
      //});
      print("setDataSource exception: $fe");
    }, test: (e) => e is FijkException);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text('直播页'),
      ),
      body: Container(
        child: FijkVolumeWatcher(
            watcher: null,
            showToast: true,
            child: FijkView(
              player: player,
              // panelBuilder: simplestUI,
              // panelBuilder: (FijkPlayer player, BuildContext context,
              //     Size viewSize, Rect texturePos) {
              //   return CustomFijkPanel(
              //       player: player,
              //       buildContext: context,
              //       viewSize: viewSize,
              //       texturePos: texturePos);
              // },
            )),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    player.release();
  }
}


//class homePag extends StatelessWidget{
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      child: RaisedButton(
//        child: Image(
//          image: NetworkImage("https://s2.ax1x.com/2019/09/04/nVUFeS.jpg"),
//          fit: BoxFit.fill,
//        ),
//      ),
//      margin: EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
//      width: 240.0,
//      //高度,list已经设置了
//    );
//  }
//}
//getHuanCun() async{
//  SharedPreferences prefs = await SharedPreferences.getInstance();
//  await print(prefs.get('counter') + "读取缓存上一页缓存");
//}
