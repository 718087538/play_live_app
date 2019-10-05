import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Chat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new  MaterialApp(
        title: "dsda",
        home: Scaffold(
            appBar: AppBar(
              title: Text('聊天室'),
            ),
            body: new msgList())
    );
  }
}

class msgList extends StatefulWidget{
  _msgList createState() => _msgList();
}

class _msgList extends State<msgList> {
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
          return _leftInkWel(list,index,context);
        },
      ),
    );
  }
}


Widget _leftInkWel(list,int index,context){

  return InkWell(
    child: Container(
      height: 40.0,
      width: 300.0,
      child: Column(
          children: <Widget>[
            Text("直播分类: "+list[index]["title"]),
          ]),
//      child: Text(list[index]["title"]),
    ),
  );
}