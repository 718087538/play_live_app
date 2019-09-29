import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('请登录'),
      ),
      body: Padding(
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
            ),
            TextField(
              obscureText: true, //密码框
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "请输入密码",
                  labelText: "密码"),
            )
          ],
        ),
      ),
    );
  }
}
