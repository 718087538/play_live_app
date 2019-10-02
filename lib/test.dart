import 'package:congra_app/playRoom.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


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
  

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount:list.length,
        itemBuilder: (context,index){
          return _leftInkWel(list,index);
        },
      ),
    );
  }
}


getList() async{
  print("这里应该请求直播列表2222");
  var url = 'http://192.168.0.200:7001/api/live/room';
  var response = await http.get(url);
  var data = await jsonDecode(response.body);
  var list = data["data"]["roomInfo"];
//  print('打印列表y: ${list}');
    list.forEach((item)=>print(item));
}

Widget _leftInkWel(list,int index){
  return InkWell(
    onTap: (){},
    child: Container(
      height: 100.0,
      child: Column(
  children: <Widget>[
    Text(list[index]["title"]),
  ]),
//      child: Text(list[index]["title"]),
    ),
  );
}