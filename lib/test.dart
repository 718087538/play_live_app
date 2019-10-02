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

class HomePage extends StatelessWidget {
  //不好的渲染效果
//  final _items = List<Widget>.generate(10, (i) => Container(padding: EdgeInsets.all(16.0), child: Text("Item $i")));
  final _items = List<Widget>.generate(10, (i) => Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
          children: <Widget>[

            Image.network("https://s2.ax1x.com/2019/09/04/nVUFeS.jpg"),
            Text("我是标题",
              style: new TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                letterSpacing: 4.0,

              ),
            ),
            Text("我是富标题",
              style: new TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              letterSpacing: 4.0,
            ),),
          ]
      ))
  
  );

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _items,
    );
  }

//相对来说好一点而已
//  final _items = List<String>.generate(10, (i) => "Item $i");
//
//  @override
//  Widget build(BuildContext context) {
//    return ListView.builder(
//      itemCount: 10,
//      itemBuilder: (context, idx) {
//        return Container(
//          padding: EdgeInsets.all(16.0),
//          child: Text(_items[idx]),
//        );
//      },
//    );
//  }

}