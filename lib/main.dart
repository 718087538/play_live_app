import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Im Title32'),
        ),
          body: new RoomList()
      )
    );
  }
}

class RoomList extends StatelessWidget{
  @override
  Widget build (BuildContext context){
    return ListView.builder(
        itemCount: 100,
        itemExtent: 100.0, //强制高度为50.0
        itemBuilder: (BuildContext context, int index) {
          return ListTile(title: Text("$index"));
        }
    );
  }

}