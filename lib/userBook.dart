import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'widgets/BlogFeed.dart';
import 'package:http/http.dart' as http;
import 'values/urls.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class UserBook extends StatefulWidget {
  String attribute;
  UserBook({@required this.attribute});
  @override
  _UserBookState createState() => _UserBookState();
}

class _UserBookState extends State<UserBook> {
  @override
  var data = [];
  bool gotData = false;
  void initState() {
    super.initState();
  }

//liked and saved posts in drawer
  Future getMarkedPosts(user_id) async {
    http.Response res = await http.post(getLikedSavedPosts,
        body: {"user_id": user_id, "attribute": widget.attribute});
    var data = jsonDecode(res.body.toString());
//    print(data);
    return data;
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    var dataDummy =
        await getMarkedPosts(Provider.of<String>(context, listen: false));
    setState(() {
      data = dataDummy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'oswald'),
      home: GestureDetector(
        onLongPress: () {
          didChangeDependencies();
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: Colors.black,
            title: widget.attribute == 'liked'
                ? Icon(FontAwesomeIcons.solidHeart)
                : Icon(FontAwesomeIcons.solidBookmark),
          ),
          body: SafeArea(
            child: data.length >= 0
                ? ListView.builder(
                    padding: EdgeInsets.all(0),
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      var dataObject = data[data.length - 1 - index];
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
          ),
        ),
      ),
    );
  }
}
