import 'package:flutter/material.dart';

import 'test.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter Demo',
        //注册路由表
        routes:{
          "home_page":(context)=>MyApp(),
//          "new_page":(context)=>EchoRoute(),
//          "tip2": (context){
//            return TipRoute(text: ModalRoute.of(context).settings.arguments);
//          },
        } ,
        home: Scaffold(
            appBar: AppBar(
              title: Text('Im Tit221e22'),
            ),
            body: new RoomList()));
  }
}

//列表
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
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return Login();
          }));
        },
      ),
      margin: EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
      width: 240.0,
      //高度,list已经设置了
    );
  }
}
