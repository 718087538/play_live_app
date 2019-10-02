import 'package:flutter/material.dart';

void main() {
  runApp(new Login());
}

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Myapp",
      home: new HomePage(),
    );
  }
}
//不好的渲染效果
class HomePage extends StatelessWidget {
//  final _items = List<Widget>.generate(10,
//          (i) => Container(padding: EdgeInsets.all(16.0), child: Text("Item $i")));
//
//  @override
//  Widget build(BuildContext context) {
//    return ListView(
//      children: _items,
//    );
//  }
  final _items = List<String>.generate(1000, (i) => "Item $i");

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1000,
      itemBuilder: (context, idx) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Text(_items[idx]),
        );
      },
    );
  }

}