import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
var uuid = new Uuid();


class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    fetchData();
    return Scaffold(
        appBar: AppBar(
          title: Text('测试页'),
        ),
        body: new MyForm());
  }
}

class MyForm extends StatefulWidget {
  MyForm({Key key}) : super(key: key);

  _MyForm createState() => _MyForm();
}

class _MyForm extends State<MyForm> {
//var _username = new TextEditingController();//这个方法用于初始化赋值,如果不赋值,下面的方法更好
  var _mobile;
  var _password;

  @override
//  void initState() {
//    super.initState();
//    _username.text = '初始值';
//  }

  @override
  Widget build(BuildContext context) {

    SvgPicture close = new SvgPicture.asset(
        "assets/seting.svg"
    );

    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            width: 50.0,
            height: 50.0,
            child: close,
          ),
          SizedBox(
            height: 20.0,
          ),
          TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "请输入账号",
                labelText: "账号",
              ),
              onChanged: (value) {
                setState(() {
                  _mobile.text = value;
                });
              }),

          SizedBox(height: 20.0),//高度20的盒子,可以当空行用

          TextField(
              obscureText: true, //密码框
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "请输入密码",
                  labelText: "密码"),
              onChanged: (value) {
                setState(() {
                  //把文本框的值实时赋给一个变量
                  this._password = value;
                });
              }),
          SizedBox(height: 20.0),
          Container(
            width: double.infinity, //让按钮宽度自适应
            height: 50.0,
            child: RaisedButton(
              child: Text("登录"),
              onPressed: () {
//                print(this._mobile.text); //打印输入框的值
//                print(this._password); //打印输入框的值.密码不用加.text

                Login2();
//                huanCun();
              },
              color: Colors.blue,
              textColor: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}

//获取验证码图片
fetchData() async {
  var url = 'http://192.168.0.200:7001/api/svg';
  var response = await http.post(url, body: {'uuid': '987654147'});
  print('Response status: ${response.statusCode}');
//  print('Response body: ${response.body}');
  var _data = await jsonDecode(  response.body);
  print('Response body: ${_data["data"]["svgCode"]}');//可以获得svg图片

}

Login2() async{
  var url = 'http://192.168.0.200:7001/api/student/login';
  var response = await http.post(url, body: {'mobile': '15989161080','password': '1234567890c'});
//    print('Response status: ${response.statusCode}');
//    print('Response body: ${response.body}');
  var data = await jsonDecode(response.body);
  print('Response body: ${data["data"]["token"]}');
  String token = data["data"]["token"];
  //把token缓存起来.
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
  await print("查看token"+prefs.get('token'));

}

//设置缓存试试
huanCun() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String counter = "100000000000000";
//  await prefs.setString('counter', counter);

  await print(prefs.get('counter')+"读取缓存");
}