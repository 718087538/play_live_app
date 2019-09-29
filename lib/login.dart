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
            TextField(),
            SizedBox(height: 20.0,),
            TextField(
              decoration: InputDecoration(
                hintText: "请输入账号"
              ),
            )
          ],
        ),
      ),
    );
  }
}

