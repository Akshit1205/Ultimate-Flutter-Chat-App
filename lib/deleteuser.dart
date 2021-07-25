import 'dart:io';
import 'constant.dart';
import 'database.dart';
import 'widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'finallyadduser.dart';
import 'finaldelete.dart';

class DeleteUser extends StatefulWidget {
  final String groupchatroomID;

  DeleteUser(this.groupchatroomID);
  @override
  _DeleteUserState createState() => _DeleteUserState();
}

class _DeleteUserState extends State<DeleteUser> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatroomStream;
  final ScrollController _scrollController = ScrollController();
  bool _needsScroll = false;

  _scrollToEnd() async {
    if (_needsScroll) {
      _needsScroll = false;
      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 800,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut);
    }
  }

  @override
  void initState() {
    initiateSearch();
    super.initState();
  }

  initiateSearch() {
    databaseMethods
        .usersPresentInGroupSnpshots(widget.groupchatroomID)
        .then((val) {
      setState(() {
        chatroomStream = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
    return Scaffold(
      appBar: AppBar(
        title: Text("Remove a user"),
      ),
      body: new Row(
        children: <Widget>[
          Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: StreamBuilder(
                stream: chatroomStream,
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            // print(snapshot
                            //     .documents[index].data["name"]
                            //     .toString());
                            return ChatRoomTile(
                                snapshot.data.documents[index].data["name"]
                                    .toString(),
                                snapshot.data.documents[index].data["email"]
                                    .toString(),
                                widget.groupchatroomID);
                          },
                        )
                      : Container();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatRoomTile extends StatefulWidget {
  final String username;
  final String useremail;
  final String groupchatroomID;
  ChatRoomTile(this.username, this.useremail, this.groupchatroomID);
  @override
  _ChatRoomTileState createState() => _ChatRoomTileState();
}

class _ChatRoomTileState extends State<ChatRoomTile> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot issuperadminSnapshot;
  QuerySnapshot ispresentSnapshot;

  @override
  void initState() {
    initiateSearch();
    super.initState();
  }

  initiateSearch() {
    databaseMethods.usersPresentInGroup(widget.groupchatroomID).then((val) {
      setState(() {
        issuperadminSnapshot = val;
      });
    });
  }

  bool isAlreadyPresent(String username) {
    databaseMethods.usersPresentInGroup(widget.groupchatroomID).then((val) {
      setState(() {
        ispresentSnapshot = val;
      });
    });

    if (ispresentSnapshot != null) {
      for (var i = 0; i < ispresentSnapshot.documents.length; i++) {
        if (username ==
            ispresentSnapshot.documents[i].data["name"].toString()) {
          return true;
        }
      }

      return false;
    }
  }

  bool isSuperAdmin() {
    if (issuperadminSnapshot != null) {
      for (var i = 0; i < issuperadminSnapshot.documents.length; i++) {
        if (widget.username ==
            issuperadminSnapshot.documents[i].data["name"].toString()) {
          if (issuperadminSnapshot.documents[i].data["superadmin"]) {
            return true;
          }
        }
      }
      return false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!isSuperAdmin() && (widget.username != Constants.myName)) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      FinalDelete(widget.groupchatroomID, widget.username)));
        }
      },
      child: Container(
        color: Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        margin: EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text(
                "${widget.username.substring(0, 1).toUpperCase()}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.username,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    widget.useremail,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
