import 'package:congra_app/playRoom.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    getList();

    return new MaterialApp(
        title: 'Flutter Demo',

        home: Scaffold(
            appBar: AppBar(
              title: Text('空格教育测试'),
            ),
            body: new LeftCategoryNav ()));
  }
}

//左侧导航菜单
class LeftCategoryNav extends StatefulWidget {
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}


class _LeftCategoryNavState extends State<LeftCategoryNav> {



  List list=[
    {'title':"123456"},
    {'title':"123456"},
    {'title':"123456"},
    {'title':"123456"},
  ];
  void _getCategory()async{
    var url = 'http://192.168.0.200:7001/api/live/room';
    var response = await http.get(url);
      var data = await jsonDecode(response.body);
      setState(() {
        list =data["data"]["roomInfo"];
      });
  }
  @override
  Widget build(BuildContext context) {
    _getCategory();

    return Container(
      child: ListView.builder(
        itemCount:list.length,
        itemBuilder: (context,index){
          return _leftInkWel(list,index,context);
        },
      ),
    );
  }
}


getList() async{
//  print("这里应该请求直播列表2222");
  var url = 'http://192.168.0.200:7001/api/live/room';
  var response = await http.get(url);
  var data = await jsonDecode(response.body);
  var list = data["data"]["roomInfo"];

//  print('打印列表y: ${list}');
//    list.forEach((item)=>print(item));
}

Widget _leftInkWel(list,int index,context){

  return InkWell(
    //既然不能路由传参,那就设置缓存喽,到时候再研究路由传参.
    onTap: () async{
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
      height: 130.0,
      width: 300.0,
      child: Column(
  children: <Widget>[
    Text("直播间名: "+list[index]["title"]),
    Text("直播分类: "+list[index]["description"]),
    Image.network(list[index]["imgUrl"],
      fit: BoxFit.fill,
    ),
  ]),
//      child: Text(list[index]["title"]),
    ),
  );
}




