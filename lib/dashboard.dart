import 'dart:convert';
import 'package:socialapp/login.dart';
import 'package:socialapp/userBook.dart';
import 'widgets/MyTextFormField.dart';
import 'widgets/UserData.dart';
import 'widgets/SubmitButton.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'values/urls.dart';
import 'package:socialapp/widgets/BottomNavbar.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

Future<UserData> getUserData(user_id) async {
  http.Response res = await http.post(loggedUserData, body: {"id": user_id});
  if (res.body.isNotEmpty) {
    var data = jsonDecode(res.body);
    UserData userData = UserData(
        id: data[0]['id'],
        username: data[0]['username'],
        bio: data[0]['bio'],
        profile_pic: data[0]['profile_pic']);
    return userData;
  } else
    return UserData();
}

////liked and saved posts in drawer
//Future getMarkedPosts(user_id, attribute) async {
//  http.Response res = await http.post(getLikedSavedPosts,
//      body: {"user_id": user_id, "attribute": attribute});
//  var data = jsonDecode(res.body.toString());
//  print(data);
//}

class _DashboardState extends State<Dashboard> {
//Update user Profile
  Future editUserData(user_id, attribute, value) async {
    http.Response res = await http.post(editUserProfileUrl,
        body: {"user_id": user_id, "attribute": attribute, "value": value});
    print(res.body);
    var data = jsonDecode(res.body);
    print(data);
  }

//dialog box
  Future dialogBox(user_id, String title, BuildContext context, String oldValue,
      String hintText, String attribute) async {
    String value = oldValue;
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            elevation: 1.0,
            backgroundColor: Colors.black,
            title: Text(
              title,
              style: TextStyle(color: Colors.white),
            ),
            children: <Widget>[
              SimpleDialogOption(
                child: MyTextFormField(
                  hintText: hintText,
                  value: oldValue,
                  onChanged: (val) {
                    setState(() {
                      value = val;
                    });
                  },
                ),
              ),
              SimpleDialogOption(
                child: SubmitButton(
                  submitText: 'Submit',
                  onPressed: () async {
                    await editUserData(user_id, attribute, value);
                    didChangeDependencies();
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      userData = UserData();
    });
  }

  var userPosts = [];
  bool gotData = false;
  UserData userData = UserData();
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    userData = await getUserData(Provider.of<String>(context, listen: false));
    setState(() {
      gotData = true;
    });
    await getUserPosts(userData.username);
  }

  Future getUserPosts(username) async {
    http.Response res = await http.post(getUrl, body: {"author": username});
    var data = jsonDecode(res.body);
    setState(() {
      userPosts = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<String>(
      builder: (context, provider, child) => MaterialApp(
          theme: ThemeData(fontFamily: "oswald"),
          home: Scaffold(
            drawer: Drawer(
              child: Container(
                color: Colors.black,
                child: ListView(
                  padding: EdgeInsets.all(0),
                  children: <Widget>[
                    DrawerHeader(
                      child: Row(
                        children: <Widget>[
                          Text('My Book',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.book,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    UserBook(attribute: 'saved')));
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.bookmark,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Saved posts',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                        ],
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    UserBook(attribute: 'liked')));
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.heart,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Liked posts',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                        ],
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginForm()),
                            (route) => false);
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.backward,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Logout',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            appBar: AppBar(
              backgroundColor: Colors.black54,
              actions: <Widget>[
                GestureDetector(
                  child: Icon(FontAwesomeIcons.book),
                  onTap: () {
//              open a screen with saved and liked posts
                  },
                ),
                SizedBox(
                  width: 20,
                )
              ],
            ),
            bottomNavigationBar: Navbar(),
            backgroundColor: Colors.black,
            body: gotData
                ? SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          UserProfile(
                              username: userData.username ?? ' ',
                              photoUrl: userData.profile_pic.toString() ?? ''),
                          SizedBox(
                            height: 20.0,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(userData.bio ?? "aaa",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white)),
                          SizedBox(
                            height: 15.0,
                          ),
                          Row(
//                        crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              FlatButton(
                                  color: Colors.redAccent,
                                  onPressed: () {
                                    dialogBox(
                                        Provider.of<String>(context,
                                            listen: false),
                                        'Change DP',
                                        context,
                                        userData.profile_pic,
                                        "Photo url",
                                        "profile_pic");
                                  },
                                  child: Text(
                                    'Change profile pic',
                                    style: TextStyle(color: Colors.white),
                                  )),
                              FlatButton(
                                  color: Colors.redAccent,
                                  onPressed: () {
                                    dialogBox(
                                        Provider.of<String>(context,
                                            listen: false),
                                        'Edit Bio',
                                        context,
                                        userData.bio,
                                        "Bio goes here..",
                                        "bio");
                                  },
                                  child: Text(
                                    'Edit Bio',
                                    style: TextStyle(color: Colors.white),
                                  ))
                            ],
                          ),
                          Divider(
                            height: 10,
                            color: Colors.white,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: userPosts.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var dataObject =
                                      userPosts[userPosts.length - 1 - index];
                                  return Column(
                                    children: <Widget>[
                                      Container(
                                        child: ListTile(
                                          leading: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3,
                                            color: Colors.white,
                                            child: Image.network(
                                              dataObject['photo_url'],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          trailing: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: Text(
                                              dataObject['title'],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.white,
                                        height: 5.0,
                                      )
                                    ],
                                  );
                                }),
                          )
                        ],
                      ),
                    ),
                  )
                : Center(child: CircularProgressIndicator()),
          )),
    );
  }
}

class UserProfile extends StatelessWidget {
  final String username;
  final String photoUrl;
  UserProfile({this.username, this.photoUrl});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          height: 100,
          width: 100,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: photoUrl,
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
                  Image.asset('assets/error.jpeg'),
            ),
          ),
        ),
        Text(
          username,
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ],
    );
  }
}

class DashboardTitle extends StatelessWidget {
  final String title;
  DashboardTitle({@required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.w700, color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
