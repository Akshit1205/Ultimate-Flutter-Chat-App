import 'dart:io';
import 'constant.dart';
import 'database.dart';
import 'widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'database.dart';

class FinalMakeAdmin extends StatefulWidget {
  final String groupchatroomID;
  final String username;

  FinalMakeAdmin(this.groupchatroomID, this.username);
  @override
  _FinalMakeAdminState createState() => _FinalMakeAdminState();
}

class _FinalMakeAdminState extends State<FinalMakeAdmin> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  String userEmail;
  QuerySnapshot searchSnapshot;
  QuerySnapshot ispresentSnapshot;
  bool isPresent = true;

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
  }

  isAlreadyPresent() {
    databaseMethods.usersPresentInGroup(widget.groupchatroomID).then((val) {
      setState(() {
        ispresentSnapshot = val;
      });
    });

    if (ispresentSnapshot != null) {
      for (var i = 0; i < ispresentSnapshot.documents.length; i++) {
        if (widget.username ==
            ispresentSnapshot.documents[i].data["name"].toString()) {
          isPresent = true;
          break;
        }
      }

      isPresent = false;
    }
  }

  makeAdmin() {
    if (searchSnapshot != null) {
      for (var i = 0; i < searchSnapshot.documents.length; i++) {
        if (widget.username ==
            searchSnapshot.documents[i].data["name"].toString()) {
          print(searchSnapshot.documents[i].data["name"].toString());
          databaseMethods.makehimAdmin(widget.groupchatroomID, widget.username);
          return;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Want to make him admin"),
        ),
        body: Center(
            child: Column(children: <Widget>[
          Container(
            height: 50,
            width: 500,
            margin: EdgeInsets.all(25),
            child: FlatButton(
              child: Text(
                'Yes , Make the user admin',
                style: TextStyle(fontSize: 20.0),
              ),
              color: Colors.blueAccent,
              textColor: Colors.white,
              onPressed: () {
                makeAdmin();
              },
            ),
          ),
          Container(
            height: 50,
            width: 500,
            margin: EdgeInsets.all(25),
            child: FlatButton(
              child: Text(
                'Nope',
                style: TextStyle(fontSize: 20.0),
              ),
              color: Colors.blueAccent,
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        ])));
  }
}
