import 'package:congra_app/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

var uuid = new Uuid();

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    fetchData();
    return Scaffold(
        resizeToAvoidBottomInset:false,
        appBar: AppBar(
          title: Text('登录'),
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
  String _password2;
  String _password;

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
            width: 300.0,
            height: 120.0,
            child: Image.asset("assets/loginLogo.png"),
          ),
          SizedBox(
            height: 20.0,
          ),
          TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "请输入账号",
                  labelText: "账号"),
              onChanged: (value) {
                setState(() {
                  //把文本框的值实时赋给一个变量
                  _password2 = value;
                });
              }),

          SizedBox(height: 20.0), //高度20的盒子,可以当空行用
          TextField(
              obscureText: true, //密码框
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "请输入密码",
                  labelText: "密码"),
              onChanged: (value) {
                setState(() {
                  //把文本框的值实时赋给一个变量
                  _password = value;
                });
              }),

          SizedBox(height: 20.0),
          Container(
            width: double.infinity, //让按钮宽度自适应
            height: 50.0,
            child: RaisedButton(
              child: Text("登录"),
              onPressed: () {
                print("账号"+this._password2); //打印输入框的值
                print("密码"+this._password); //打印输入框的值.密码不用加.text
                Login2(context,_password2,_password);
//                huanCun();
              },
              color: Colors.blue,
              textColor: Colors.white,
            ),
          ),
          SizedBox(
            height: 60.0,
          ),
          Text("联系邮箱:congra002@163.com")
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
  var _data = await jsonDecode(response.body);
  print('Response body: ${_data["data"]["svgCode"]}'); //可以获得svg图片
}


//用于登录的方法.用到了
Login2(context , _mobile ,_password) async {
  var url = 'https://admin.congraedu.cn/api/student/login';
  var response = await http
      .post(url, body: {'mobile':_mobile, 'password': _password});
//    print('Response status: ${response.statusCode}');
//    print('Response body: ${response.body}');



  var data = await jsonDecode(response.body);
  print('Response body: ${data}');
  var _code = data["code"];
  if(_code == 200){
    String token = data["data"]["token"];
    String name = data["data"]["name"];
    String uid = data["data"]["uid"];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    //把token缓存起来.
    await prefs.setString('token', token);
    await prefs.setString('name', name);
    await prefs.setString('uid', uid);
//  await print("查看token"+prefs.get('token'));

    //登录成功跳转到首页
//    Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyApp()));
    //命名路由传递参数
//    Navigator.of(context).pushNamed("home_page");
    Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(builder: (context) => new MyApp()
        ), (route) => route == null);
  }else{
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('密码错误'),
        ));
  }
}

//设置缓存试试
huanCun() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String counter = "100000000000000";
//  await prefs.setString('counter', counter);

  await print(prefs.get('counter') + "读取缓存");
}
