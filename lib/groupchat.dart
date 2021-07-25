import 'dart:io';
import 'constant.dart';
import 'database.dart';
import 'widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'adduseringroup.dart';
import 'groupinfo.dart';

class GroupConversation extends StatefulWidget {
  final String chatRoomId;

  GroupConversation(this.chatRoomId);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<GroupConversation> {
  Stream<QuerySnapshot> chats;
  final ScrollController _scrollController = ScrollController();
  bool _needsScroll = false;
  bool _visible = true;
  QuerySnapshot isAdminSnapshot;
  TextEditingController messageEditingController = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot snapshot;

  _scrollToEnd() async {
    if (_needsScroll) {
      _needsScroll = false;
      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 800,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut);
    }
  }

  Widget chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return MessageTile(
                    message: snapshot.data.documents[index].data["message"],
                    sendBy: snapshot.data.documents[index].data["sendBy"],
                  );
                })
            : Container();
      },
    );
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myName,
        "message": messageEditingController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseMethods().addConversationMessagestoGroupChat(
          widget.chatRoomId, chatMessageMap);

      if (snapshot != null) {
        for (var i = 0; i < snapshot.documents.length; i++) {
          String sendByuser = snapshot.documents[i].data["name"].toString();

          if (sendByuser != Constants.myName) {
            Map<String, dynamic> chatMessageMapforNotifications = {
              "sendBy": Constants.myName,
              "message": messageEditingController.text,
              'time': DateTime.now().millisecondsSinceEpoch,
              "id": widget.chatRoomId,
              "type": "group",
            };

            DatabaseMethods().addNotifications(
                sendByuser, widget.chatRoomId, chatMessageMapforNotifications);
          }
        }
      }

      setState(() {
        messageEditingController.text = "";
      });

      //() => _controller.jumpTo(_controller.position.maxScrollExtent);
    }
  }

  // void initState() {
  //   isAdmin();
  //   super.initState();
  // }

  bool isAdmin() {
    databaseMethods.usersPresentInGroup(widget.chatRoomId).then((val) {
      setState(() {
        isAdminSnapshot = val;
      });
    });

    if (isAdminSnapshot != null) {
      for (var i = 0; i < isAdminSnapshot.documents.length; i++) {
        if (Constants.myName ==
            isAdminSnapshot.documents[i].data["name"].toString()) {
          if (isAdminSnapshot.documents[i].data["admin"]) {
            return true;
          }
        }
      }

      return false;
    }

    return false;
  }

  initiateSearch() {
    databaseMethods.usersPresentInGroup(widget.chatRoomId).then((val) {
      setState(() {
        snapshot = val;
      });
    });
  }

  @override
  void initState() {
    DatabaseMethods()
        .getConversationMessagesfromGroup(widget.chatRoomId)
        .then((val) {
      setState(() {
        chats = val;
      });
    });
    initiateSearch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatRoomId),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GroupInfo(widget.chatRoomId)));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Image.asset("assets/3dot.png")),
          ),
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            chatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                color: Colors.grey,
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: messageEditingController,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                          hintText: "Type your message ...",
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
                        if (messageEditingController.text.toString() != "") {
                          addMessage();
                        }
                        _visible = !_visible;
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
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final String sendBy;

  MessageTile({@required this.message, @required this.sendBy});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: Constants.myName == sendBy ? 0 : 24,
          right: Constants.myName == sendBy ? 24 : 0),
      alignment: Constants.myName == sendBy
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: Constants.myName == sendBy
            ? EdgeInsets.only(left: 30)
            : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: Constants.myName == sendBy
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: Constants.myName == sendBy
                  ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                  : [const Color(0xFFBBDEFB), const Color(0xFFBBDEFB)],
              //: [const Color(0xff007EF4), const Color(0xff2A75BC)],
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text((Constants.myName == sendBy) ? Constants.myName : sendBy,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Constants.myName == sendBy
                        ? Colors.white
                        : Colors.black,
                    fontSize: 15,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w500)),
            Text(message,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Constants.myName == sendBy
                        ? Colors.white
                        : Colors.black,
                    fontSize: 18,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
