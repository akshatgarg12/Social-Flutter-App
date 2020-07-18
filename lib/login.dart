import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:socialapp/home.dart';
import 'widgets/FormField.dart';
import 'widgets/SubmitButton.dart';
import 'registration.dart';
import 'values/fonts.dart';
import 'package:http/http.dart' as http;
import 'values/urls.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  String _uid = '';
  String _password = '';
  bool usernameWrong = false;
  bool passwordWrong = false;
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: bodyFont),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                usernameWrong
                    ? Text(
                        'username provided was wrong!',
                        style: TextStyle(color: Colors.red),
                      )
                    : SizedBox(),
                passwordWrong
                    ? Text(
                        'password provided was wrong!',
                        style: TextStyle(color: Colors.red),
                      )
                    : SizedBox(),
                Text(
                  'Social',
                  style: TextStyle(
                      fontSize: 60.0,
                      color: Colors.redAccent,
                      fontFamily: titleFont),
                ),
                SocialFormField(
                  hintText: 'e-mail or username',
                  iconType: Icons.mail,
                  onChanged: (val) {
                    setState(() {
                      _uid = val;
                    });
                  },
                  validator: (val) {},
                ),
                SizedBox(height: 10),
                SocialFormField(
                  obsecureText: true,
                  hintText: 'password',
                  iconType: FontAwesomeIcons.key,
                  onChanged: (val) {
                    _password = val;
                  },
                ),
                SizedBox(height: 10),
                SubmitButton(
                  submitText: 'Log-in',
                  onPressed: () async {
                    var str = await sendUserData(_uid, _password);
                    if (str['status'] == 200) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyApp(
                              user_id: str['user_id'],
                            ),
                          ),
                          (route) => false);
                    } else {
                      print(str);
//                      username wrong
                      if (str['status'] == 402) {
                        setState(() {
                          usernameWrong = true;
                          passwordWrong = false;
                        });
//                        password wrong
                      } else {
                        setState(() {
                          usernameWrong = false;
                          passwordWrong = true;
                        });
                      }
                    }
                  },
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterForm()));
                  },
                  child: Container(
                    child: Text(
                      'Don\' have an account? Register',
                      style: TextStyle(
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<Map> sendUserData(uid, pass) async {
  http.Response res = await http.post(loginUrl, body: {
    "uid": uid,
    "password": pass,
  });
  var msg = jsonDecode(res.body);
  print(msg.toString());
  return msg;
}
