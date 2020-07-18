import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'widgets/BlogPost.dart';
import 'widgets/MyTextFormField.dart';
import 'values/urls.dart';
import 'widgets/BottomNavbar.dart';
import 'package:provider/provider.dart';
import 'home.dart';

class addBlog extends StatefulWidget {
  @override
  _addBlogState createState() => _addBlogState();
}

BlogPost post = new BlogPost();
bool showNameError = false;
bool showTitleError = false;
bool showBodyError = false;
String authorName = '';

class _addBlogState extends State<addBlog> {
  @override
  void initState() {
    super.initState();
    post = new BlogPost();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var user_id = Provider.of<String>(context);
    getUsername(user_id);
  }

  Future getUsername(user_id) async {
    http.Response res = await http.post(loggedUserData, body: {"id": user_id});
    var data = jsonDecode(res.body);
    setState(() {
      post.author = data[0]['username'];
      authorName = data[0]['username'];
    });
    print(data);
  }

  Widget build(BuildContext context) {
    //validators
    bool validateName(String name) {
      if (name.length >= 2) {
        setState(() {
          showNameError = false;
        });
        return true;
      } else {
        setState(() {
          showNameError = true;
        });
        return false;
      }
    }

    bool validateTitle(String title) {
      if (title.length >= 5 && title.length <= 65) {
        setState(() {
          showTitleError = false;
        });
        return true;
      } else {
        setState(() {
          showTitleError = true;
        });
        return false;
      }
    }

    bool validateBody(String body) {
      if (body.length >= 150) {
        setState(() {
          showBodyError = false;
        });
        return true;
      } else {
        setState(() {
          showBodyError = true;
        });

        return false;
      }
    }

    final maxwidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar: Navbar(),
        backgroundColor: Colors.black12,
        body: SafeArea(
          child: Form(
            child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "author: $authorName",
                        style: TextStyle(color: Colors.white70, fontSize: 18.0),
                      ),
                      showNameError
                          ? Text(
                              "the name must be longer",
                              style: TextStyle(color: Colors.red),
                            )
                          : Icon(
                              Icons.check,
                              color: Colors.greenAccent,
                              size: 5.0,
                            ),
                      MyTextFormField(
                        hintText: "title of your post",
                        onChanged: (value) {
                          setState(() {
                            post.title = value;
                          });
                        },
                      ),
                      showTitleError
                          ? Text(
                              "the title must be between 5 to 65 chars.",
                              style: TextStyle(color: Colors.red),
                            )
                          : Icon(
                              Icons.check,
                              color: Colors.greenAccent,
                              size: 5.0,
                            ),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        margin: EdgeInsets.all(0),
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              post.body = value;
                            });
                          },
                          maxLines: 20,
                          decoration: InputDecoration(
                            hintText: 'main body' ?? null,
                            contentPadding: EdgeInsets.all(15.0),
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      showBodyError
                          ? Text(
                              "the body must be longer than 100 words.",
                              style: TextStyle(color: Colors.red),
                            )
                          : Icon(
                              Icons.check,
                              color: Colors.greenAccent,
                              size: 5.0,
                            ),
                      MyTextFormField(
                        hintText: "Url of a photo!",
                        onChanged: (value) {
                          setState(() {
                            post.photoUrl = value;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                            onPressed: () {
                              validateBody(post.body);
                              validateTitle(post.title);
                              if (validateBody(post.body) &&
                                  validateTitle(post.title)) {
                                sendData(post);
                                post = new BlogPost();
                                print('success');
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyApp(
                                        user_id: Provider.of<String>(context),
                                      ),
                                    ),
                                    (route) => false);
//                                Navigator.of(context).pushNamedAndRemoveUntil(
//                                    '/feed', (route) => false);
                              } else {
                                print('failed');
                              }
                            },
                            color: Colors.redAccent,
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              width: maxwidth,
                              height: MediaQuery.of(context).size.height / 20,
                              child: Text(
                                'Publish!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800),
                              ),
                            )),
                      )
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}

// functions sending and receiving data
Future sendData(BlogPost posts) async {
  var url = postUrl;
  http.Response response = await http.post(url, body: {
    'author': posts.author,
    'title': posts.title,
    'body': posts.body,
    'photo_url': posts.photoUrl,
  });
  print(response.body);
  if (response.body == 'success')
    return true;
  else
    return false;
}

Future getPhoto(url) async {
  http.Response res = await http.get(url);
  if (res.statusCode == 200)
    return true;
  else
    return false;
}
