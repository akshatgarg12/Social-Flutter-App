import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:socialapp/login.dart';
import 'package:socialapp/values/fonts.dart';
import 'package:socialapp/values/urls.dart';
import 'widgets/FormField.dart';
import 'widgets/SubmitButton.dart';
import 'package:http/http.dart' as http;

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  String pass1;
  String pass2;
  String email;
  String username;
  bool userCreated = false;
  bool usernameError = false;
  bool passwordError = false;
  bool alreadyExistsError = false;
  bool passNotMatch = false;
  @override
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
                userCreated
                    ? Text(
                        'user successfully registered',
                        style: TextStyle(color: Colors.green),
                      )
                    : SizedBox(),
                passNotMatch
                    ? Text(
                        'passwords don\'t match',
                        style: TextStyle(color: Colors.red),
                      )
                    : SizedBox(),
                usernameError
                    ? Text(
                        'enter a valid email or username',
                        style: TextStyle(color: Colors.red),
                      )
                    : SizedBox(),
                passwordError
                    ? Text(
                        'password must have more than 7 chars',
                        style: TextStyle(color: Colors.red),
                      )
                    : SizedBox(),
                alreadyExistsError
                    ? Text(
                        'An account already exists with this email or username',
                        style: TextStyle(color: Colors.red),
                      )
                    : SizedBox(),
                Text(
                  '*Fill all the fields',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, fontSize: 18),
                ),
                Text(
                  'Social',
                  style: TextStyle(
                      fontSize: 60.0,
                      color: Colors.redAccent,
                      fontFamily: titleFont),
                ),
                SocialFormField(
                  hintText: 'username',
                  iconType: FontAwesomeIcons.user,
                  onChanged: (val) {
                    setState(() {
                      username = val;
                    });
                  },
                ),
                SizedBox(height: 10),
                SocialFormField(
                  hintText: 'e-mail',
                  iconType: Icons.mail,
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                ),
                SizedBox(height: 10),
                SocialFormField(
                  obsecureText: true,
                  hintText: 'password',
                  iconType: FontAwesomeIcons.key,
                  onChanged: (val) {
                    setState(() {
                      pass1 = val;
                    });
                  },
                ),
                SizedBox(height: 10),
                SocialFormField(
                  obsecureText: true,
                  hintText: 'Re-enter password',
                  iconType: FontAwesomeIcons.key,
                  onChanged: (val) {
                    setState(() {
                      pass2 = val;
                    });
                  },
                ),
                SizedBox(height: 10),
                SubmitButton(
                  submitText: 'Register',
                  onPressed: () async {
                    if (pass1 == pass2) {
//                      send data
                      var code = await registerUser(email, username, pass1);
                      if (code == 200) {
                        print('user successfully registered');
                        setState(() {
                          userCreated = true;
                          usernameError = passNotMatch =
                              alreadyExistsError = passwordError = false;
                        });
                      } else if (code == 401) {
                        print('password must have more than 7 chars');
                        setState(() {
                          passwordError = true;
                          alreadyExistsError = passNotMatch =
                              userCreated = usernameError = false;
                        });
                      } else if (code == 402) {
                        print('enter a valid email or username');
                        setState(() {
                          usernameError = true;
                          alreadyExistsError = passNotMatch =
                              userCreated = passwordError = false;
                        });
                      } else if (code == 403) {
                        print(
                            'An account already exists with this email or username');
                        setState(() {
                          alreadyExistsError = true;
                          passNotMatch = usernameError =
                              userCreated = passwordError = false;
                        });
                      } else if (code == 406) {
                        print('Fill all the fields');
                      } else if (code == 500) {
                        print('some unidentified error! try again');
                      }
                    } else {
                      setState(() {
                        passNotMatch = true;
                        alreadyExistsError =
                            usernameError = userCreated = passwordError = false;
                      });
                      print('the entered password doesn\'t match');
                    }
                  },
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginForm()));
                  },
                  child: Text(
                    'Already have an account! Login',
                    style: TextStyle(
                      color: Colors.redAccent,
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

Future registerUser(email, username, pass) async {
  http.Response res = await http.post(userRegisterUrl,
      body: {"username": username, "email": email, "password": pass});
  return jsonDecode(res.body);
}
// "https://socialbytriumph.000webhostapp.com/Api/registerUser.php"
