import 'constant.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'database.dart';

class CreateGroup extends StatefulWidget {
  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  TextEditingController textTC = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot searchSnapshot;
  QuerySnapshot searchSnapshot2;

  String userEmail;

  @override
  void initState() {
    initiateSearch();
    initiateSearch2();
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
        if (Constants.myName.toString() ==
            searchSnapshot.documents[i].data["name"].toString()) {
          userEmail = searchSnapshot.documents[i].data["email"].toString();
          break;
        }
      }
    }
  }

  bool initiateSearch2() {
    databaseMethods.getAllGroups().then((val) {
      setState(() {
        searchSnapshot2 = val;
      });
    });

    if (searchSnapshot2 != null) {
      for (var i = 0; i < searchSnapshot2.documents.length; i++) {
        if (textTC.text ==
            searchSnapshot2.documents[i].data["chatroomID"].toString()) {
          return true;
        }
      }

      return false;
    }
  }

  createGroup() {
    initiateSearch();
    Map<String, dynamic> groupchatInfoMap = {
      "chatroomID": textTC.text.toString(),
    };

    Map<String, dynamic> userInfoMap = {
      "name": Constants.myName,
      "email": userEmail,
      "admin": true,
      "superadmin": true,
    };

    databaseMethods.createGroupChatRoom(
        textTC.text.toString(), groupchatInfoMap);

    databaseMethods.addUsertoGroup(
        textTC.text.toString(), userInfoMap, Constants.myName);
    databaseMethods.addGroupToUser(
        textTC.text.toString(), groupchatInfoMap, Constants.myName);

    userEmail = "";

    setState(() {
      textTC.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create a new group"),
      ),
      body: Container(
        // alignment: Alignment.bottomCenter,
        width: MediaQuery.of(context).size.width,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          color: Colors.grey,
          child: Row(
            children: [
              Expanded(
                  child: TextField(
                controller: textTC,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                    hintText: "Type a Group name ...",
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    border: InputBorder.none),
              )),
              SizedBox(
                width: 16,
              ),
              GestureDetector(
                onTap: () {
                  if (!initiateSearch2()) {
                    createGroup();
                  }
                },
                child: Container(
                  //height: 40,
                  //width: 40,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0x36FFFFFF),
                          const Color(0x0FFFFFFF)
                        ],
                        // begin: FractionalOffset.topLeft,
                        // end: FractionalOffset.bottomRight
                      ),
                      borderRadius: BorderRadius.circular(40)),
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.send, size: 30),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
