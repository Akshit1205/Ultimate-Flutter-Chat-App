import 'dart:io';
import 'constant.dart';
import 'database.dart';
import 'widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'database.dart';

class Adduser extends StatefulWidget {
  final String groupchatroomID;
  final String username;

  Adduser(this.groupchatroomID, this.username);
  @override
  _AdduserState createState() => _AdduserState();
}

class _AdduserState extends State<Adduser> {
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

    if (searchSnapshot != null) {
      for (var i = 0; i < searchSnapshot.documents.length; i++) {
        if (widget.username ==
            searchSnapshot.documents[i].data["name"].toString()) {
          userEmail = searchSnapshot.documents[i].data["email"].toString();
          break;
        }
      }
    }
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

  addusertogroup() {
    initiateSearch();
    Map<String, dynamic> groupchatInfoMap = {
      "chatroomID": widget.groupchatroomID
    };

    Map<String, dynamic> userInfoMap = {
      "name": widget.username,
      "email": userEmail,
      "admin": false,
      "superadmin": false,
    };

    //databaseMethods.createGroupChatRoom(
    //  widget.groupchatroomID, groupchatInfoMap);

    databaseMethods.addUsertoGroup(
        widget.groupchatroomID, userInfoMap, widget.username);
    databaseMethods.addGroupToUser(
        widget.groupchatroomID, groupchatInfoMap, widget.username);

    userEmail = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Want to add or not"),
        ),
        body: Center(
            child: Column(children: <Widget>[
          Container(
            height: 50,
            width: 500,
            margin: EdgeInsets.all(25),
            child: FlatButton(
              child: Text(
                'Yes , Add the user',
                style: TextStyle(fontSize: 20.0),
              ),
              color: Colors.blueAccent,
              textColor: Colors.white,
              onPressed: () {
                addusertogroup();
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
