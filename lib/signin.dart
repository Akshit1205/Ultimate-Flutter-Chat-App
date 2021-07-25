import 'package:finalflutter/chat.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'widgets/widget.dart';
import 'extra.dart';
import 'home.dart';
import 'database.dart';
import 'constant.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isLoading = false;
  bool inDatabase = false;
  bool rightpassword = false;
  String password;
  final formKey = GlobalKey<FormState>();
  QuerySnapshot searchSnapshot;

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController emailTC = new TextEditingController();
  TextEditingController passwordTC = new TextEditingController();
  String signInPassword;

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
        if (emailTC.text.toString() ==
            searchSnapshot.documents[i].data["email"].toString()) {
          Constants.myName =
              searchSnapshot.documents[i].data["name"].toString();
          signInPassword =
              searchSnapshot.documents[i].data["password"].toString();

          inDatabase = true;

          break;
        }
      }
    }
  }

  String getPassword(String email) {
    for (var i = 0; i < Constants.arr.length; i++) {
      if (Constants.arr[i].useremail == email) {
        return Constants.arr[i].password;
      }
    }

    return "";
  }

  checkpassword(String a, String b) {
    if (a == b)
      rightpassword = true;
    else
      rightpassword = false;
  }

  signMeup() {
    initiateSearch();
    if (formKey.currentState.validate() &&
        inDatabase &&
        passwordTC.text == signInPassword) {
      password = getPassword(emailTC.text);
      checkpassword(password, passwordTC.text.toString());
      if (true) {
        // print(password);
        // print(
        //     "sdfjs;ldjlksjdsl;adjfsldjfisjdskdvjskdjsldkfjs;lfjad;lfasdjflskd f dlfkjskdl;fj;lsajdfas");

        setState(() {
          isLoading = true;
        });

        Constants.fromSignIn = true;
        Constants.fromSignUp = false;

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Chat()));
        inDatabase = false;
        password = "";
        rightpassword = false;
      }
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
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          validator: (val) {
                            return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val) &&
                                    inDatabase
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
                          validator: (val) {
                            return val.length > 6 &&
                                    (passwordTC.text == signInPassword)
                                ? null
                                : "Please enter the correct password";
                          },
                          obscureText: true,
                          controller: passwordTC,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          decoration: textFieldInputDecoration("password"),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 18, vertical: 8),
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
                            signMeup();
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
                            child: Text("Sign In",
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
                              "Don't have an account?",
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
                                  "Register now",
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
