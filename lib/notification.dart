import 'dart:io';
import 'constant.dart';
import 'database.dart';
import 'widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'finallyadduser.dart';
import 'groupchat.dart';
import 'conservationscreen.dart';
import 'alert_notification.dart';
import 'home.dart';

class Notifications extends StatefulWidget {
  //final String groupchatroomID;

  //Notifications(this.groupchatroomID);
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
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
    databaseMethods.notificationsSnapshot(Constants.myName).then((val) {
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
        title: Text("Notifications"),
        actions: [
          // GestureDetector(
          //   onTap: () {
          //     Navigator.push(
          //         context, MaterialPageRoute(builder: (context) => Alerts()));
          //   },
          //   child: Container(
          //       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          //       child: Image.asset("assets/alert_icon.png")),
          // ),
          // GestureDetector(
          //     onTap: () {
          //       Navigator.pushReplacement(
          //           context, MaterialPageRoute(builder: (context) => Extra()));
          //     },
          //     child: Container(
          //       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          //       child: Icon(Icons.home),
          //     )),
        ],
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
                              snapshot.data.documents[index].data["sendBy"]
                                  .toString(),
                              snapshot.data.documents[index].data["type"]
                                  .toString(),
                              snapshot.data.documents[index].data["id"]
                                  .toString(),
                              // widget.groupchatroomID
                            );
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
  final String type;
  final String groupchatroomID;
  ChatRoomTile(this.username, this.type, this.groupchatroomID);
  @override
  _ChatRoomTileState createState() => _ChatRoomTileState();
}

class _ChatRoomTileState extends State<ChatRoomTile> {
  DatabaseMethods databaseMethods = new DatabaseMethods();

  QuerySnapshot ispresentSnapshot;

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.type == "individual") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ConservationScreen(widget.groupchatroomID)));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      GroupConversation(widget.groupchatroomID)));
        }

        databaseMethods.deleteNotification(
            widget.groupchatroomID, Constants.myName);
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
              child: widget.type == "group"
                  ? Text(
                      "${widget.groupchatroomID.substring(0, 1).toUpperCase()}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    )
                  : Text(
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
                  widget.type == "individual"
                      ? Text(
                          widget.username,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        )
                      : Text(
                          widget.groupchatroomID,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                  // SizedBox(
                  //   height: 4,
                  // ),
                  // Text(
                  //   widget.useremail,
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 18,
                  //   ),
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
