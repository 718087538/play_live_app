import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Im Title222'),
        ),
          body: Center(
            child: RaisedButton(
              child: Text('返回'),
            ),
          ),
      )
    );
  }
}