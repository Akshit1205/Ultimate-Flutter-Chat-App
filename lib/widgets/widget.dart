import 'package:flutter/material.dart';
//import 'package:finalflutter/def/def.dart';

Widget appbarMain(BuildContext context) {
  return AppBar(
    title: Text(
      "Chat App",
      style: TextStyle(
        color: Colors.white,
        fontSize: 30,
      ),
    ),
    toolbarHeight: 100,
    //backgroundColor: Colors.blueAccent,
    actions: [
      //GestureDetector(
      // onTap: () {
      //   Navigator.push(
      //       context, MaterialPageRoute(builder: (context) => Alerts()));
      //},
      Container(
          padding: EdgeInsets.symmetric(horizontal: 60, vertical: 8),
          child: Image.asset("assets/chaticon.png")),
      //),
    ],
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color: Colors.white54,
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white54),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white54),
    ),
  );
}
