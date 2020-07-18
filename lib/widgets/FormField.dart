import 'package:flutter/material.dart';

class SocialFormField extends StatelessWidget {
  final String hintText;
  final IconData iconType;
  final Function validator;
  final Function onChanged;
  final bool obsecureText;
  SocialFormField(
      {this.hintText,
      this.iconType,
      this.validator,
      this.onChanged,
      this.obsecureText});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obsecureText ?? false,
      validator: validator ?? null,
      onChanged: onChanged ?? null,
      decoration: InputDecoration(
        hintText: hintText,
        icon: Icon(
          iconType,
          color: Colors.redAccent,
        ),
        contentPadding: EdgeInsets.all(10.0),
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }
}
