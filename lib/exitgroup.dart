import 'dart:io';
import 'constant.dart';
import 'database.dart';
import 'widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'database.dart';

class ExitGroup extends StatefulWidget {
  final String groupchatroomID;

  ExitGroup(this.groupchatroomID);
  @override
  _FinalDeleteState createState() => _FinalDeleteState();
}

class _FinalDeleteState extends State<ExitGroup> {
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

  // isAlreadyPresent() {
  //   databaseMethods.usersPresentInGroup(widget.groupchatroomID).then((val) {
  //     setState(() {
  //       ispresentSnapshot = val;
  //     });
  //   });

  //   if (ispresentSnapshot != null) {
  //     for (var i = 0; i < ispresentSnapshot.documents.length; i++) {
  //       if (widget.username ==
  //           ispresentSnapshot.documents[i].data["name"].toString()) {
  //         isPresent = true;
  //         break;
  //       }
  //     }

  //     isPresent = false;
  //   }
  // }

  deleteuser() {
    if (searchSnapshot != null) {
      for (var i = 0; i < searchSnapshot.documents.length; i++) {
        if (Constants.myName ==
            searchSnapshot.documents[i].data["name"].toString()) {
          print(searchSnapshot.documents[i].data["name"].toString());
          databaseMethods.deleteUser(widget.groupchatroomID, Constants.myName);
          databaseMethods.deleteGroupFromUser(
              widget.groupchatroomID, Constants.myName);
          return;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Want to exit the group?"),
        ),
        body: Center(
            child: Column(children: <Widget>[
          Container(
            height: 50,
            width: 500,
            margin: EdgeInsets.all(25),
            // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: FlatButton(
              child: Text(
                'Yes , EXIT',
                style: TextStyle(fontSize: 20.0),
              ),
              color: Colors.blueAccent,
              textColor: Colors.white,
              onPressed: () {
                deleteuser();
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
