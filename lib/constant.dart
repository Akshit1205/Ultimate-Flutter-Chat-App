import 'package:flutter/material.dart';

class emailpass {
  String useremail;
  String password;
  emailpass(this.useremail, this.password);
}

class Constants {
  static String myName = "";
  static bool fromSignIn = false;
  static bool fromSignUp = false;

  static List<emailpass> arr = [];
}
