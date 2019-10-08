import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adhara_socket_io/adhara_socket_io.dart';

class Chat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('直播间'),
        ),
        body: new msgList());
  }
}



class msgList extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

const String URI = "https://admin.congraedu.cn/api/chat";

class _MyAppState extends State<msgList> {
  List<String> toPrint = ["trying to connect"];
  SocketIOManager manager;
  Map<String, SocketIO> sockets = {};
  Map<String, bool> _isProbablyConnected = {};

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
            "msg": "100000000000000000000000",
            "name": "kkkk",
            "uid": "5d903b209ab56f70dcd03ff9",
          }
        }
      ]);
      print("已发出留言");
    }
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
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            child: RaisedButton(
              child: Text("Connect"),
              onPressed: ipc ? null : () => initSocket(identifier),
              padding: EdgeInsets.symmetric(horizontal: 8.0),
            ),
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: RaisedButton(
                child: Text("Send Message"),
                onPressed: ipc ? () => sendMessage(identifier) : null,
                padding: EdgeInsets.symmetric(horizontal: 8.0),
              )),
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
          color: Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  child: Center(
                    child: ListView(
//                      children: toPrint.map((String _) => Text(_ ?? "")).toList(),
                    ),
                  )),
              Padding(
                padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                child: Text(
                  "Default Connection",
                ),
              ),
              getButtonSet("default"),

            ],
          ),
        ),
      ),
    );
  }
}
