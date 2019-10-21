import 'package:congra_app/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:async/async.dart';
import 'dart:async';

var uuid = new Uuid();

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    fetchData();

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('注册账号'),
        ),
        body: new MyForm());
  }
}

class MyForm extends StatefulWidget {
  MyForm({Key key}) : super(key: key);

  _MyForm createState() => _MyForm();
}

Timer _timer;
num _verifyTime; //全局的按钮倒计时时间
bool canPressBtn = true; //能否点击按钮
String _btnName = "发送验证码";

class _MyForm extends State<MyForm> {
//var _username = new TextEditingController();//这个方法用于初始化赋值,如果不赋值,下面的方法更好
  String _password2 = ""; //手机号,不知道为什么改成其他的名字就不行了
  String _password = ""; //密码
  String _rePassword = ""; //密码
  String _verify = ""; //验证码的内容
  String _name = "";

  @override
  ttt() async {
    _timer = new Timer(const Duration(milliseconds: 4000), () {
      setState(() {
        _btnName = "发送验证码";
        canPressBtn = true;
      });
    });
  }

  //获取手机验证码
  getVerify() async {
    if (_password2 == "") {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('手机号不能为空!'),
              ));
      return false;
    }

    if (canPressBtn == false) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('请1分钟后再发送!'),
              ));
      return false;
    }

    setState(() {
      canPressBtn = false;
      _btnName = "已发送";
    });
    ttt();

    try{
      var response = await http.post('https://admin.congraedu.cn/api/sms', body: {
        'mobile': _password2,
        'type':"1",
      });

      var data = await jsonDecode(response.body);
      print('发送验证码的结果: ${data["code"]}');
    }catch(error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          TextField(
              maxLength: 11, //最长输入字数
              keyboardType: TextInputType.phone, //键盘类型

              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "请输入手机号",
                  labelText: "手机号"),
              onChanged: (value) {
                setState(() {
                  //把文本框的值实时赋给一个变量
                  _password2 = value;
                });
              }),

          SizedBox(height: 10.0), //高度20的盒子,可以当空行用
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

          TextField(
              obscureText: true, //密码框
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "重复密码",
                  labelText: "重复密码"),
              onChanged: (value) {
                setState(() {
                  //把文本框的值实时赋给一个变量
                  _rePassword = value;
                });
              }),

          SizedBox(height: 20.0),

          Row(children: <Widget>[
            Expanded(
              child: TextField(
                  keyboardType: TextInputType.phone, //键盘类型
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "验证码"),
                  onChanged: (value) {
                    setState(() {
                      //把文本框的值实时赋给一个变量
                      _verify = value;
                    });
                  }),
            ),
            Expanded(
              child: Text(""),
            ),
            RaisedButton(
              padding: EdgeInsets.all(20.0),
              child: Text('${_btnName}'),
              onPressed: () {
                getVerify();
              },
              color: Colors.blue,
              textColor: Colors.white,
            )
          ]),
          SizedBox(
            height: 10.0,
          ),
          TextField(
              keyboardType: TextInputType.phone, //键盘类型
              decoration: InputDecoration(
                  hintText: "用户名",
                  border: OutlineInputBorder(),
                  labelText: "用户名"),
              onChanged: (value) {
                setState(() {
                  //把文本框的值实时赋给一个变量
                  _name = value;
                });
              }),

          SizedBox(height: 20.0),

          Container(
            width: double.infinity, //让按钮宽度自适应
            height: 50.0,
            child: RaisedButton(
              child: Text("立即注册"),
              onPressed: () {
                print("账号" + this._password2); //打印输入框的值
                print("密码" + this._password); //打印输入框的值.密码不用加.text
                Register2(
                  context,
                  _password2,
                  _password,
                  _rePassword,
                  _name,
                  _verify,
                );
//                huanCun();
              },
              color: Colors.blue,
              textColor: Colors.white,
            ),
          ),
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
Register2(context, _mobile, _password, _rePassword, _name, _verify) async {
  if (_mobile == "") {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('请输入账号!'),
            ));
    return false;
  }

  if (_password == "") {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('请输入密码!'),
            ));
    return false;
  }

  if (_rePassword == "") {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('请输入重复密码!'),
            ));
    return false;
  }

  if (_verify == "") {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('请输入验证码!'),
            ));
    return false;
  }
  if (_name == "") {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('请输入用户名!'),
            ));
    return false;
  }

  if (_password != _rePassword) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('两次密码不一致!'),
        ));
    return false;
  }


  var url = 'https://admin.congraedu.cn/api/v1/user';
  var response =
      await http.post(url, body: {'mobile': _mobile, 'password': _password,'username':_name,'smsCode':_verify});

  var data = await jsonDecode(response.body);
  print('Response body: ${data}');
  var _code = data["code"];
  if (_code == 201) {
//    showDialog(
//        context: context,
//        builder: (context) => AlertDialog(
//          title: Text('注册成功!'),
//        ));

    Navigator.pushNamed(context, "login_page");
  } else if( _code == 604){

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('验证码错误!'),
            ));
  }else if( _code == 603){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('验证码过期!'),
        ));
  } else if(_code == 1000){

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('账号已被注册!'),
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
