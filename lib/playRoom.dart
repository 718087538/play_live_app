import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayRoom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    getHuanCun();
      return Scaffold(
          appBar: AppBar(
            title: Text('直播间'),
          ),
          body: new homePag());
  }
}

class homePag extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        child: Image(
          image: NetworkImage("https://s2.ax1x.com/2019/09/04/nVUFeS.jpg"),
          fit: BoxFit.fill,
        ),
      ),
      margin: EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
      width: 240.0,
      //高度,list已经设置了
    );
  }
}
getHuanCun() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await print(prefs.get('counter') + "读取缓存上一页缓存");

}
