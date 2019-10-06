import 'package:congra_app/list.dart';
import 'package:congra_app/playRoom.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'test.dart';
import 'playRoom.dart';
import 'test3.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    getList();

    return new MaterialApp(
        title: 'Flutter Demo',
        //注册路由表
        routes: {
          "home_page": (context) => MyApp(),
          "login_page": (context) => Login(),
          "play_room": (context) => PlayRoom(),
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

class _RoomBox2 extends State<RoomBox2>{
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 500.0,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text("已登录:某某用户"),
                ),

                RaisedButton(
                  child: Text("去登陆"),
                  onPressed: (){

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
    var url = 'http://192.168.0.200:7001/api/live/room';
    var response = await http.get(url);
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
      print("我被点击了");

      String counter = "100000000000000";
      await prefs.setString('counter', counter);
//      await print(prefs.get('counter') + "读取+替代路由传参");

      //设置完缓存就可以去另外的页面读取缓存了
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) {
        return PlayRoom();
      }));
    },
    child: Container(
      color: Colors.grey[400],
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
          child: Text("描述: " + list[index]["description"],
              style: TextStyle(
                fontSize: 20.0,
              )),
        ),
      ]),
//      child: Text(list[index]["title"]),
    ),
  );
}

class RoomList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemExtent: 200.0, //强制高度为50.0
      itemBuilder: (BuildContext context, int index) {
        return new RoomBox();
      },
    );
  }
}

//直播间的容器
class RoomBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        child: Image(
          image: NetworkImage("https://s2.ax1x.com/2019/09/04/nVUFeS.jpg"),
          fit: BoxFit.fill,
        ),
        onPressed: () {
//          Navigator.pushNamed(context, "Login");
          //route跳转可行
//          Navigator.of(context)
//              .push(MaterialPageRoute(builder: (BuildContext context) {
//            return Login();
//          }));
          goPlay(context);
        },
      ),
      margin: EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
      width: 240.0,
      //高度,list已经设置了
    );
  }
}

goPlay(context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
//  await print("查看token"+prefs.get('token'));
  //如果找不到token就代表没有登录,则跳到登录.
  if (prefs.get('token') == "" || prefs.get('token') == null) {
    print("没token,前往登录");
    Navigator.of(context).pushNamed("login_page");
  } else {
    print("已登录");
//    Navigator.of(context).pushNamed("play_room");
    Navigator.of(context).pushNamed("chat");
  }
}

getList() async {
//  print("这里应该请求直播列表");
  var url = 'http://192.168.0.200:7001/api/live/room';
  var response = await http.get(url);
  var data = await jsonDecode(response.body);
//  print('Response body: ${data["data"]["roomInfo"]}');
}
