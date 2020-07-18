import 'package:flutter/material.dart';
import 'package:socialapp/login.dart';
import 'widgets/BottomNavbar.dart';
import 'widgets/BlogFeed.dart';
import 'package:provider/provider.dart';
import 'values/urls.dart';
import 'values/fonts.dart';
import 'dart:async';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';

class MyApp extends StatefulWidget {
//  getting the id of the user logged in.
  // ignore: non_constant_identifier_names
  var user_id;
  // ignore: non_constant_identifier_names
  MyApp({Key key, @required this.user_id}) : super(key: key);

  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  var data = [];

  Future getData() async {
    var url = getUrl;
    http.Response response = await http.get(url);
    var datajson = jsonDecode(response.body);
    setState(() {
      data = datajson;
    });
  }

  void callData() async {
    getData();
  }

  @override
  void initState() {
    super.initState();
    getData();
    print(widget.user_id);
    if (widget.user_id == null) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

  Widget build(BuildContext context) {
//    print(widget.user_id);
    return Provider<String>(
        create: (context) => widget.user_id,
        child: Consumer<String>(
          builder: (context, provider, child) => MaterialApp(
              title: 'Social By Triumph',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                fontFamily: bodyFont,
              ),
              home: GestureDetector(
                  onLongPress: () {
                    callData();
                  },
                  child: Scaffold(
                      appBar: AppBar(
                        title: Text(
                          'Social',
                          style: TextStyle(
                              fontFamily: titleFont,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0),
                        ),
                        centerTitle: true,
                        backgroundColor: Colors.black,
                        actions: <Widget>[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                widget.user_id = null;
                              });

                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginForm()),
                                  (route) => false);
//                    Navigator.pushNamed(context, r);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginForm()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'logout',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 25.0,
                          ),
                        ],
                      ),
                      backgroundColor: Color(323232),
                      bottomNavigationBar: Navbar(),
                      body: SafeArea(
                        child: data.length > 0
                            ? ListView.builder(
                                padding: EdgeInsets.all(0),
                                itemCount: data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var dataObject =
                                      data[data.length - 1 - index];
                                  return PostCard(
                                    post_id: dataObject['id'],
                                    author: dataObject['author'],
                                    title: dataObject['title'],
                                    body: dataObject['body'],
                                    photo_url: dataObject['photo_url'],
                                    created_at: dataObject['created_at'],
                                  );
                                })
                            : Center(
                                child: CircularProgressIndicator(),
                              ),
                      )))),
        ));
  }
}
