import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:http/http.dart' as http;

String pppUrl;

class PlayRoom extends StatefulWidget {
  PlayRoom({Key key, this.title}) :super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<PlayRoom>  {
  disconnect(String identifier) async {
    await manager.clearInstance(sockets[identifier]);
    setState(() => _isProbablyConnected[identifier] = false);
  }
  //点击返回时弹出框
  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('提醒'),
        content: new Text('是否退出学习?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('否'),
          ),
          new FlatButton(
            onPressed: () async{
              await disconnect("default");
              await Navigator.of(context).pop(true);
            },
            child: new Text('是'),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
//获取路由参数
    var args = ModalRoute.of(context).settings.arguments;
    pppUrl = args;
    return new WillPopScope(
      onWillPop:_onWillPop,
      child:Scaffold(
          appBar: AppBar(
            title: Text('直播间'),
          ),
          body: new myAppState())
    );
  }
}

//播放直播视频
class PlayPage extends StatefulWidget {
  _PlayPage createState() => _PlayPage();
}
class _PlayPage extends State<PlayPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 500.0,
        height: 650.0,
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            VideoScreen(),
//            msgList(),
            sendMsg(),
          ],
        ));
  }
}

//发送消息
class sendMsg extends StatefulWidget {
  _sendMsg createState() => _sendMsg();
}
class _sendMsg extends State<sendMsg> {
  String msgContent;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              decoration:
                  InputDecoration(border: OutlineInputBorder(), hintText: "发言"),
            ),
          ),
          RaisedButton(
            padding: EdgeInsets.all(20),
            color: Colors.red,
            textColor: Colors.white,
            child: Text('发送'),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}

//展示消息内容
class msgList extends StatefulWidget {
  _msgList createState() => _msgList();
}

List list = [
  {'name': " ", 'msg': " ", 'uid': "   "},
];
class _msgList extends State<msgList> {
  ScrollController _scrollController = new ScrollController();
  //重置数组列表
  num changeNum = 0;
  change() {
    setState(() {
      list = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (changeNum < 1) {
      change();
      changeNum++; //不小于1就好
    }

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
            Text(
              list[index]["name"],
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
  String playUrl = "";

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
    String playUrls = "rtmp://202.69.69.180:443/webcast/bshdlive-pc";
    test(pppUrl);
  }
}
//从这里开始上面不动


class myAppState extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
const String URI = "https://admin.congraedu.cn/api/chat";

//暂存发言的内容
String sendContentValue222 = "";
List<String> toPrint = ["trying to connect"];
SocketIOManager manager;
Map<String, SocketIO> sockets = {};
Map<String, bool> _isProbablyConnected = {};


//与socket相关的内容,都在这里.
class _MyAppState extends State<myAppState> {

//  String sendContentValue = "";
  @override
  void initState() {
    super.initState();
    manager = SocketIOManager();
    initSocket("default");
  }

//  socket建立连接
  initSocket(String identifier) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String roomID = await prefs.get('roomID');
    setState(() => _isProbablyConnected[identifier] = true);
    SocketIO socket = await manager.createInstance(SocketOptions(
        //Socket IO server URI
        URI,
        nameSpace: (identifier == "namespaced") ? "/adhara" : "/",
        //Query params - can be used for authentication
        query: {
          "token": prefs.get('token'),
          "room": roomID,
          "userId": DateTime.now().toString()
        },
        //Enable or disable platform channel logging
        enableLogging: false,
        transports: [
          Transports.WEB_SOCKET /*, Transports.POLLING*/
        ] //Enable required transport
        ));
    socket.onConnect((data) {
      print("connected..连接成功连接成功连接成功连接成功.");
      print(data);
//      sendMessage(identifier);
    });
    socket.onDisconnect(pprint);
    socket.on("chat", (data) => pprint(data));
    socket.connect();
    sockets[identifier] = socket;
  }

  bool isProbablyConnected(String identifier) {
    return _isProbablyConnected[identifier] ?? false;
  }

  //断开socket的方法.
  disconnect(String identifier) async {
    await manager.clearInstance(sockets[identifier]);
    setState(() => _isProbablyConnected[identifier] = false);
  }

  sendMessage(identifier) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.get('name');
    String uid = prefs.get('uid');
    String roomID = await prefs.get('roomID');

    //房间号
//     String target = prefs.get('name');
    if (sockets[identifier] != null) {
      sockets[identifier].emit("chat", [
        {
          "target": roomID,
          "payload": {
            "msg": sendContentValue222,
            "name": name,
            "uid": uid,
          }
        }
      ]);
      print("已发出留言");
    }
  }

  //ack确认消息,用不到
  sendMessageWithACK(identifier) {
//    pprint("Sending ACK message from '$identifier'...");
    List msg = [
      "Hello world!",
    ];
    sockets[identifier].emitWithAck("ack-message", msg).then((data) {});
  }

  //打印出信息
  pprint(data) {
    setState(() {
      print(list.length);
      //模仿上下滚动的效果
      if (list.length > 6) {
        print("删除1个");
        list.removeAt(1);
        print(list);
      }
      list.add(data["data"]["payload"]); //添加进数组
    });
  }

  final TextEditingController _controller = new TextEditingController();

  Container getButtonSet(String identifier) {
    bool ipc = isProbablyConnected(identifier);
    return Container(
      height: 60.0,
      padding: EdgeInsets.only(left: 6.0, right: 6.0),
      margin: EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: "发言"),
                onChanged: (value) {
                  setState(() {
                    //把文本框的值实时赋给一个变量
                    sendContentValue222 = value;
                  });
                }),
          ),
          Container(
            margin: EdgeInsets.only(left: 6.0),
            child: RaisedButton(
                padding: EdgeInsets.all(20),
                color: Colors.red,
                textColor: Colors.white,
                child: Text('发送'),
//              onPressed: ipc ? () => sendMessage(identifier) : null,
                onPressed: () {
                  sendMessage(identifier);
                  _controller.clear();
                }),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
//          color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          VideoScreen(),
          msgList(),
          getButtonSet("default"),
        ],
      ),
    );
  }
}
