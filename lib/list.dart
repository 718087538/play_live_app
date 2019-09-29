import 'package:flutter/material.dart';

class Home extends StatelessWidget{
  @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('首页'),),
      body: Center(
        child: RaisedButton(
          child: Text('跳转2222'),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(
            ));
          },
        ),
      ),
    );
  }
}
