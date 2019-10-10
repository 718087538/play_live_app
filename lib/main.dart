import 'package:congra_app/list.dart';
import 'package:congra_app/playRoom.dart';
import 'package:congra_app/playRoom.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//import 'test.dart';
import 'login.dart';
import 'playRoom.dart';
import 'test3.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter Demo',
        //注册路由表
        routes: {
          "home_page": (context) => MyApp(),
          "login_page": (context) => Login(),
          "play_room": (context) => PlayRoom(),
          'playRoom': (BuildContext context) => PlayRoom(),
          "chat": (context) => Chat(),
//          "tip2": (context){
//            return TipRoute(text: ModalRoute.of(context).settings.arguments);
//          },
        },
        home: Scaffold(
            appBar: AppBar(
              title: Text('空格教育'),
            ),
            body: RoomBox2()));
//            body: LeftCategoryNav()));
  }
}

//顶部登录状态
class RoomBox2 extends StatefulWidget {
  _RoomBox2 createState() => _RoomBox2();
}

class _RoomBox2 extends State<RoomBox2> {
  String _loginStatus = "未登录";
  String _btnName = "去登陆";
  bool _isLogin = true;
  num checkLoginTime = 0;

  checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get('token') == "" || prefs.get('token') == null) {
      setState(() {
        _isLogin = false;
      });
    } else {
      setState(() {
        _isLogin = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (checkLoginTime < 1) {
      checkLogin();
      checkLoginTime++;
    }
    return Container(
        width: 500.0,
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
//                  child: Text('${_loginStatus}'),
                  child: Text(
                    _isLogin ? '已登录' : '未登录',
                    style: TextStyle(
                      fontSize: 26.0, // 文字大小
                    ),
                  ),
                ),
                RaisedButton(
                  child: Text(_isLogin ? '重新登录' : '去登录'),
                  onPressed: () {
                    Navigator.pushNamed(context, "login_page");
                  },
                )
              ],
            ),
//            Test100(),
            LeftCategoryNav(),
          ],
        ));
  }
}

class Test100 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Image.network("https://s2.ax1x.com/2019/09/04/nVUFeS.jpg"),
        Image.network("https://s2.ax1x.com/2019/09/04/nVUFeS.jpg"),
      ],
    ));
  }
}

//列表
class LeftCategoryNav extends StatefulWidget {
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  List list = [
    {'title': "123456"},
  ];

  void _getCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ptoken = await prefs.get('token');

    Map<String, String> _getHeaders() {
      return <String, String>{
        'Accept': 'application/json',
        'token': ptoken,
      };
    }

//    var url = 'http://192.168.0.200:7001/api/live/room';//本地
    var url = 'https://admin.congraedu.cn/api/live/room'; //服务器
    var response = await http.get(url, headers: _getHeaders());
    var data = await jsonDecode(response.body);
    setState(() {
      list = data["data"]["roomInfo"];
    });
  }

  @override
  Widget build(BuildContext context) {
    _getCategory();

    return Expanded(
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _leftInkWel(list, index, context);
        },
      ),
    );
  }
}

Widget _leftInkWel(list, int index, context) {
  return InkWell(
    //既然不能路由传参,那就设置缓存喽,到时候再研究路由传参.
    onTap: () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print("应该没有token");
      String ptoken = await prefs.get('token');

      print("roomiDDDDDDDDDDDDD" + list[index]["roomID"]);

      if (prefs.get('token') == "" || prefs.get('token') == null) {
        print("没token,前往登录");
        Navigator.of(context).pushNamed("login_page");
      } else {
        Map<String, String> _getHeaders() {
          return <String, String>{
            'Accept': 'application/json',
            'token': ptoken,
          };
        }

        //请求直播间信息.
        var response = await http.get(
            "https://admin.congraedu.cn/api/live/room/${list[index]["roomID"]}",
            headers: _getHeaders());
        var data = await jsonDecode(response.body);
        print('0000000000000000000: ${data}');
        String canPlayUrl = data["data"]["pullUrlRtmp"];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('roomID', list[index]["roomID"]);

        print("真的url" + canPlayUrl);
        Navigator.of(context).pushNamed('playRoom', arguments:canPlayUrl);
      }
    },
    child: Container(
      color: Colors.grey[350],
      height: 230.0,
      width: 750.0,
      margin: EdgeInsets.all(10.0),
      child: Column(children: <Widget>[
        Container(
          width: 650.0,
          height: 170.0,
          child: Image.network(
            list[index]["imgUrl"],
            fit: BoxFit.fill,
            repeat: ImageRepeat.noRepeat,
          ),
        ),
        Container(
          width: 650.0,
          padding: EdgeInsets.only(left: 10.0),
          child: Text("直播间: " + list[index]["title"],
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20.0,
              )),
        ),
        Container(
          width: 650.0,
          padding: EdgeInsets.only(left: 10.0),
          child: Row(children: <Widget>[
            Expanded(
              child: Text("描述: " + list[index]["description"],
                  style: TextStyle(
                    fontSize: 20.0,
                  )),
            ),
            Container(
              padding: EdgeInsets.only(left: 20.0, right: 10.0),
              child: Text(list[index]["isLive"] ? '已开播' : '未开播',
                  style: TextStyle(
                    fontSize: 16.0,
                  )),
            )
          ]),
        ),
      ]),
//      child: Text(list[index]["title"]),
    ),
  );
}
