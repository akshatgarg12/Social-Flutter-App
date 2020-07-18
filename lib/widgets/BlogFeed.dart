import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/values/urls.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class PostCard extends StatefulWidget {
  var post_id;
  String author;
  String title;
  String body;
  String photo_url;
  String created_at;

  PostCard(
      {this.post_id,
      this.author,
      this.title,
      this.body,
      this.photo_url =
          'https://images.unsplash.com/photo-1496065187959-7f07b8353c55?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80',
      this.created_at});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool postSaved = false;
  bool postLiked = false;
  bool showFullBody = false;
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Future stateCheck(user_id, post_id, attribute) async {
    http.Response res = await http.post(stateCheckerUrl,
        body: {"user_id": user_id, "post_id": post_id, "attribute": attribute});
    var data = jsonDecode(res.body);
    return data['status'];
  }

  Future checkState() async {
    var uid = Provider.of<String>(context);
    var res = await stateCheck(uid, widget.post_id, 'like');
    if (res == 1) {
      setState(() {
        postLiked = true;
      });
    }
    res = await stateCheck(uid, widget.post_id, 'save');
    if (res == 1) {
      setState(() {
        postSaved = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    checkState();
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        if (showFullBody) {
          setState(() {
            showFullBody = false;
          });
        } else {
          setState(() {
            showFullBody = true;
          });
        }
//        open article view.
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          gradient: LinearGradient(
            colors: [Colors.black, Colors.black87],
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    widget.author,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 18.0),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    widget.created_at.toString().substring(0, 16),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.0),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: <Widget>[
                      Align(
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: widget.photo_url,
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              Image.asset('assets/error.jpeg'),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          widget.title.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                      icon: FaIcon(
                        postLiked
                            ? FontAwesomeIcons.solidHeart
                            : FontAwesomeIcons.heart,
                        color: postLiked ? Colors.redAccent : Colors.white,
                      ),
                      onPressed: () {
                        if (postLiked)
                          setState(() {
                            var user_id =
                                Provider.of<String>(context, listen: false);
//
                            likeHandle(user_id, widget.post_id, "unliked");
//                            call to delete from table
                            postLiked = false;
                          });
                        else {
                          setState(() {
                            var user_id =
                                Provider.of<String>(context, listen: false);
                            likeHandle(user_id, widget.post_id, "liked");
//                            call to add to likes table
                            postLiked = true;
                          });
                        }
                      }),
                  IconButton(
                      icon: FaIcon(
                        postSaved
                            ? FontAwesomeIcons.solidBookmark
                            : FontAwesomeIcons.bookmark,
                        color: postSaved ? Colors.redAccent : Colors.white,
                      ),
                      onPressed: () {
                        if (postSaved)
                          setState(() {
                            var user_id =
                                Provider.of<String>(context, listen: false);
                            saveHandle(user_id, widget.post_id, "unsaved");
                            postSaved = false;
                          });
                        else {
                          setState(() {
                            var user_id =
                                Provider.of<String>(context, listen: false);
                            saveHandle(user_id, widget.post_id, "saved");
                            postSaved = true;
                          });
                        }
                      }),
                ],
              ),
              Text(
                showFullBody
                    ? widget.body
                    : widget.body.substring(0, 100) + '...',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16.0),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 15.0,
              ),
              Divider(
                height: 7.0,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future likeHandle(user_id, post_id, action) async {
  http.Response res = await http.post(likeHandlerUrl,
      body: {"user_id": user_id, "post_id": post_id, "action": action});
}

Future saveHandle(user_id, post_id, action) async {
  http.Response res = await http.post(saveHandlerUrl,
      body: {"user_id": user_id, "post_id": post_id, "action": action});
}

//Future checkState() async{
//  var user_id = Provider.of<String>(context, listen: false);
//  var likeResult =await stateCheck(user_id, widget.post_id, "like");
//  print(likeResult);
//  // ignore: unrelated_type_equality_checks
//  if (likeResult == 1) {
//    setState(() {
//      postLiked = true;
//    });
//    var saveResult =await stateCheck(user_id, widget.post_id, "save");
//    // ignore: unrelated_type_equality_checks
//    if (saveResult == 1) {
//      setState(() {
//        postSaved = true;
//      });
//    }
