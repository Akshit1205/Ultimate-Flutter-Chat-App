import 'package:finalflutter/chat.dart';

import 'auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'widgets/widget.dart';
import 'auth.dart';
import 'home.dart';
import 'authenticate.dart';
import 'extra.dart';
import 'database.dart';
import 'helper.dart';
import 'constant.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  bool usernameinDatabase = false;
  bool emailinDatabase = false;

  final formKey = GlobalKey<FormState>();
  QuerySnapshot searchSnapshot;
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  TextEditingController usernameTC = new TextEditingController();
  TextEditingController emailTC = new TextEditingController();
  TextEditingController passwordTC = new TextEditingController();

  void newPost(String username, String useremail) {
    this.setState(() {
      Constants.arr.add(new emailpass(username, useremail));
    });
  }

  @override
  void initState() {
    initiateSearch();
    super.initState();
  }

  initiateSearch() {
    databaseMethods.getAllUsers().then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });

    if (searchSnapshot != null) {
      for (var i = 0; i < searchSnapshot.documents.length; i++) {
        if (usernameTC.text.toString() ==
            searchSnapshot.documents[i].data["name"].toString()) {
          usernameinDatabase = true;
        } else if (emailTC.text.toString() ==
            searchSnapshot.documents[i].data["email"].toString()) {
          emailinDatabase = true;
        }
      }
    }
  }

  signMeUp() {
    usernameinDatabase = false;
    emailinDatabase = false;

    initiateSearch();
    if (formKey.currentState.validate() &&
        !usernameinDatabase &&
        !emailinDatabase) {
      Map<String, String> userInfoMap = {
        "name": usernameTC.text,
        "email": emailTC.text,
        "password": passwordTC.text,
        "power": "user",
      };

      HelperFunctions.saveUserNameSharedPreference(usernameTC.text);
      HelperFunctions.saveUserEmailSharedPreference(emailTC.text);

      setState(() {
        isLoading = true;
      });

      authMethods
          .signUpWithEmailAndPassword(emailTC.text, passwordTC.text)
          .then((val) {
        databaseMethods.uploadUserInfo(userInfoMap, usernameTC.text);
        HelperFunctions.saveUserLoggedInSharedPreference(true);

        Constants.fromSignUp = true;
        Constants.fromSignIn = false;

        usernameinDatabase = true;
        emailinDatabase = true;

        Constants.arr.add(new emailpass(emailTC.text, passwordTC.text));

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Chat()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarMain(context),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 70,
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: newMethod(context),
                  ),
                ),
              ),
            ),
    );
  }

  List<Widget> newMethod(BuildContext context) {
    return [
      Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              validator: (val) {
                return val.isNotEmpty && val.length > 4 && !usernameinDatabase
                    ? null
                    : "Please provide a unique username of 4+ characters";
              },
              controller: usernameTC,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              decoration: textFieldInputDecoration("username"),
            ),
            TextFormField(
              validator: (val) {
                return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(val) &&
                        !emailinDatabase
                    ? null
                    : "Enter correct email";
              },
              controller: emailTC,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              decoration: textFieldInputDecoration("email"),
            ),
            TextFormField(
              obscureText: true,
              validator: (val) {
                return val.length > 6
                    ? null
                    : "Please provide a password with 6+ characters";
              },
              controller: passwordTC,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              decoration: textFieldInputDecoration("password"),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 8,
      ),
      Container(
        alignment: Alignment.centerRight,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Text(
            "Forgot Password",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
      SizedBox(
        height: 8,
      ),
      GestureDetector(
        onTap: () {
          signMeUp();
        },
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              const Color(0xff007EF4),
              const Color(0xff2A75BC),
            ]),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text("Sign Up",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              )),
        ),
      ),
      SizedBox(
        height: 16,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Already have an account?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          GestureDetector(
            onTap: () {
              widget.toggle();
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "SignIn now",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
      SizedBox(
        height: 100,
      ),
    ];
  }
}
