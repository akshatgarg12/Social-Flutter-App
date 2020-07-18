import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final String hintText;
  final Function validator;
  final Function onChanged;
  final String value;
  MyTextFormField({this.hintText, this.validator, this.onChanged, this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: hintText ?? null,
          contentPadding: EdgeInsets.all(15.0),
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.grey[200],
        ),
        obscureText: false,
        initialValue: value ?? null,
        validator: validator ?? null,
        onChanged: onChanged ?? null,
        keyboardType: TextInputType.text,
      ),
    );
  }
}
