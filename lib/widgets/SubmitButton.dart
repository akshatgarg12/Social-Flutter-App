import 'package:flutter/material.dart';
import 'package:socialapp/values/fonts.dart';

class SubmitButton extends StatelessWidget {
  final String submitText;
  final Function onPressed;
  SubmitButton({this.submitText, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: onPressed,
        child: Container(
          padding: EdgeInsets.all(8.0),
          width: MediaQuery.of(context).size.width / 4,
          color: Colors.redAccent,
          child: Text(
            submitText,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontFamily: bodyFont),
          ),
        ));
  }
}
