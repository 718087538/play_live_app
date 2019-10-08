import 'package:flutter/material.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adhara_socket_io/adhara_socket_io.dart';

class PlayRoom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('直播间'),
        ),
        body: new msgList2());
  }
}

//从这里开始不动
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

//发送消息类
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
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "发言"),

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

//消息列表类
class msgList extends StatefulWidget {
  _msgList createState() => _msgList();
}

class _msgList extends State<msgList> {
  List list = [
    {'name': "kkk", 'msg': "我是留言内容呢", 'uid': "125535352"},
    {'name': "222名", 'msg': "2222", 'uid': "125535352"},
    {'name': "222名", 'msg': "2222", 'uid': "125535352"},
    {'name': "222名", 'msg': "2222", 'uid': "125535352"},
    {'name': "222名", 'msg': "2222", 'uid': "125535352"},
    {'name': "222名", 'msg': "2222", 'uid': "125535352"},
    {'name': "222名", 'msg': "2222", 'uid': "125535352"},
    {'name': "222名", 'msg': "213123", 'uid': "125535352"},
    {'name': "222名", 'msg': "2222", 'uid': "125535352"},
    {'name': "222名", 'msg': "3246565", 'uid': "125535352"},
    {'name': "222名", 'msg': "2222", 'uid': "125535352"},
    {'name': "222名", 'msg': "2222", 'uid': "125535352"},
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

//从这里开始上面不动




class msgList2 extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

const String URI = "https://admin.congraedu.cn/api/chat";

class _MyAppState extends State<msgList2> {
  List<String> toPrint = ["trying to connect"];
  SocketIOManager manager;
  Map<String, SocketIO> sockets = {};
  Map<String, bool> _isProbablyConnected = {};
  String sendContentValue = "";
  @override
  void initState() {
    super.initState();
    manager = SocketIOManager();
    initSocket("default");
  }

//  socket建立连接
  initSocket(String identifier) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() => _isProbablyConnected[identifier] = true);
    SocketIO socket = await manager.createInstance(SocketOptions(
      //Socket IO server URI
        URI,
        nameSpace: (identifier == "namespaced") ? "/adhara" : "/",
        //Query params - can be used for authentication
        query: {
          "token": prefs.get('token'),
          "room": "1",
          "userId": DateTime.now().toString()
        },
        //Enable or disable platform channel logging
        enableLogging: false,
        transports: [
          Transports.WEB_SOCKET /*, Transports.POLLING*/
        ] //Enable required transport
    ));
    socket.onConnect((data) {
      pprint("connected..连接成功.");
      pprint(data);
      sendMessage(identifier);
    });
    socket.on("chat", (data) => pprint(data));
    socket.connect();
    sockets[identifier] = socket;
  }

  bool isProbablyConnected(String identifier) {
    return _isProbablyConnected[identifier] ?? false;
  }

  disconnect(String identifier) async {
    await manager.clearInstance(sockets[identifier]);
    setState(() => _isProbablyConnected[identifier] = false);
  }

  sendMessage(identifier) {
    if (sockets[identifier] != null) {
      print("sending message from '$identifier'...");
      sockets[identifier].emit("chat", [

        {
          "target": "1",
          "payload": {
            "msg": sendContentValue,
            "name": "kkkk",
            "uid": "5d903b209ab56f70dcd03ff9",
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
      1,
      true,
      {"p": 1},
      [3, 'r']
    ];
    sockets[identifier].emitWithAck("ack-message", msg).then((data) {
    });
  }

  //打印出信息
  pprint(data) {
    setState(() {
      if (data is Map) {
        data = json.encode(data);
      }
//      print(data);
//      toPrint.add(data);
    });
  }

  Container getButtonSet(String identifier) {
    bool ipc = isProbablyConnected(identifier);
    return Container(
      height: 60.0,
      child:
      Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "发言"),
                onChanged: (value) {
                  setState(() {
                    //把文本框的值实时赋给一个变量
                    sendContentValue = value;
                  });
                }
            ),
          ),
          RaisedButton(
            padding: EdgeInsets.all(20),
            color: Colors.red,
            textColor: Colors.white,
            child: Text('发送'),
            onPressed: ipc ? () => sendMessage(identifier) : null,
          )
        ],
      ),


    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: TextTheme(
            title: TextStyle(color: Colors.white),
            headline: TextStyle(color: Colors.white),
            subtitle: TextStyle(color: Colors.white),
            subhead: TextStyle(color: Colors.white),
            body1: TextStyle(color: Colors.white),
            body2: TextStyle(color: Colors.white),
            button: TextStyle(color: Colors.white),
            caption: TextStyle(color: Colors.white),
            overline: TextStyle(color: Colors.white),
            display1: TextStyle(color: Colors.white),
            display2: TextStyle(color: Colors.white),
            display3: TextStyle(color: Colors.white),
            display4: TextStyle(color: Colors.white),
          ),
          buttonTheme: ButtonThemeData(
              padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
              disabledColor: Colors.lightBlueAccent.withOpacity(0.5),
              buttonColor: Colors.lightBlue,
              splashColor: Colors.cyan)),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Adhara Socket.IO example'),
          backgroundColor: Colors.black,
          elevation: 0.0,
        ),
        body: Container(
//          color: Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              VideoScreen(),

              getButtonSet("default"),

            ],
          ),
        ),
      ),
    );
  }
}
