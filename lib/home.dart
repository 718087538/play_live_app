import 'package:flutter/material.dart';


void main(){
  runApp(MaterialApp(
      title: "导航演示01",
      home:new Home()
  ));
}

class Home extends StatelessWidget{
  @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('首页'),),
      body: Center(

      ),
    );
  }
}
