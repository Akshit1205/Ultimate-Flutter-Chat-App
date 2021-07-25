import 'dart:io';
import 'constant.dart';
import 'database.dart';
import 'widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'adduseringroup.dart';
import 'database.dart';
import 'groupmembers.dart';
import 'makeadmin.dart';
import 'deleteuser.dart';
import 'exitgroup.dart';
import 'deletegroup.dart';

class GroupInfo extends StatefulWidget {
  final String groupchatroomID;
  GroupInfo(this.groupchatroomID);

  @override
  _GroupInfoState createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot isAdminSnapshot;

  void initState() {
    isAdmin();
    super.initState();
  }

  bool isAdmin() {
    databaseMethods.usersPresentInGroup(widget.groupchatroomID).then((val) {
      setState(() {
        isAdminSnapshot = val;
      });
    });

    if (isAdminSnapshot != null) {
      for (var i = 0; i < isAdminSnapshot.documents.length; i++) {
        if (Constants.myName ==
            isAdminSnapshot.documents[i].data["name"].toString()) {
          if (isAdminSnapshot.documents[i].data["admin"]) {
            // isadmin = true;
            return true;
          }
        }
      }

      // isadmin = false;
      return false;
    }
    return false;
  }

  bool isSuperAdmin() {
    databaseMethods.usersPresentInGroup(widget.groupchatroomID).then((val) {
      setState(() {
        isAdminSnapshot = val;
      });
    });

    if (isAdminSnapshot != null) {
      for (var i = 0; i < isAdminSnapshot.documents.length; i++) {
        if (Constants.myName ==
            isAdminSnapshot.documents[i].data["name"].toString()) {
          if (isAdminSnapshot.documents[i].data["superadmin"]) {
            // isadmin = true;
            return true;
          }
        }
      }

      // isadmin = false;
      return false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Group Info",
            style: TextStyle(
              fontSize: 20,
            )),
      ),
      body: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          GrpMembers(widget.groupchatroomID)));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: Colors.black,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 2),
              width: MediaQuery.of(context).size.width,
              child: Text(
                "Group Members",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ExitGroup(widget.groupchatroomID)));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: Colors.black,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 2),
              width: MediaQuery.of(context).size.width,
              child: Text(
                "Exit the group",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          isAdmin()
              ? GestureDetector(
                  onTap: () {
                    if (isAdmin()) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AddUser(widget.groupchatroomID)));
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    color: Colors.black,
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(vertical: 2),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "Add a User",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : Container(),
          isAdmin()
              ? GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DeleteUser(widget.groupchatroomID)));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    color: Colors.black,
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(vertical: 2),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "Remove a User",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : Container(),
          isSuperAdmin()
              ? GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MakeAdmin(widget.groupchatroomID)));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    color: Colors.black,
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(vertical: 2),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "Make Someone Admin",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : Container(),
          isSuperAdmin()
              ? GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DeleteGroup(widget.groupchatroomID)));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    color: Colors.black,
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(vertical: 2),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "DELETE the GROUP",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
