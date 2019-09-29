import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
  var _username;
  var _password;

  @override
//  void initState() {
//    super.initState();
//    _username.text = '初始值';
//  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
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
                  //把文本框的值实时赋给一个变量
                  _username.text = value;
                });
              }),
          SizedBox(height: 20.0),

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
              },
          ),

          SizedBox(height: 20.0),
          Container(
            width: double.infinity, //让按钮宽度自适应
            height: 50.0,
            child: RaisedButton(
              child: Text("登录"),
              onPressed: () {
                print(this._username.text); //打印输入框的值
                print(this._password); //打印输入框的值.密码不用加.text
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
