import 'package:flutter/material.dart';
import 'package:socialapp/dashboard.dart';

import 'addBlog.dart';

import 'login.dart';
import 'registration.dart';
import 'home.dart';

void main() => runApp(MaterialApp(
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (BuildContext context) => LoginForm(),
        '/dashboard': (BuildContext context) => Dashboard(),
        '/register': (BuildContext context) => RegisterForm(),
        '/feed': (BuildContext context) => MyApp(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/addBlog': (BuildContext context) => addBlog(),
      },
    ));
