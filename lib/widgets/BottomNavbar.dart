import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/addBlog.dart';
import 'package:socialapp/home.dart';
import 'package:socialapp/dashboard.dart';

class Navbar extends StatelessWidget {
  const Navbar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.0),
      child: BottomNavigationBar(
        backgroundColor: Colors.black54,
        elevation: .5,
        selectedItemColor: Colors.redAccent,
        showSelectedLabels: true,
        iconSize: 25,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.search,
              color: Colors.redAccent,
            ),
            title: Text(
              'Explore',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add,
                size: 30.0,
                color: Colors.redAccent,
              ),
              title: Text(
                'Add a blog',
                style: TextStyle(color: Colors.redAccent),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.user,
                color: Colors.redAccent,
              ),
              title: Text(
                'dashboard',
                style: TextStyle(color: Colors.redAccent),
              )),
        ],
        onTap: (i) {
          if (i == 0) {
//            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => MyApp()) );
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => MyApp(
                          user_id: Provider.of<String>(context),
                        )),
                (route) => false);
          } else if (i == 1) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => addBlog()),
                (route) => false);
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Dashboard()),
                (route) => false);
          }
        },
      ),
    );
  }
}
