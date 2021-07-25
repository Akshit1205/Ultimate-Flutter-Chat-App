import 'dart:io';
import 'constant.dart';
import 'database.dart';
import 'widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConservationScreen extends StatefulWidget {
  final String chatRoomId;

  ConservationScreen(this.chatRoomId);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<ConservationScreen> {
  Stream<QuerySnapshot> chats;
  bool _visible = true;
  TextEditingController messageEditingController = new TextEditingController();

  Widget chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      message: snapshot.data.documents[index].data["message"],
                      sendByMe: Constants.myName ==
                          snapshot.data.documents[index].data["sendBy"],
                      type: snapshot.data.documents[index].data["type"]);
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
        "type": "msg",
      };

      String sendByuser = widget.chatRoomId
          .toString()
          .replaceAll("_", "")
          .replaceAll(Constants.myName, "");

      DatabaseMethods()
          .addConversationMessages(widget.chatRoomId, chatMessageMap);

      Map<String, dynamic> chatMessageMapforNotifications = {
        "sendBy": Constants.myName,
        "message": messageEditingController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
        "id": widget.chatRoomId,
        "type": "individual",
      };
      DatabaseMethods().addNotifications(
          sendByuser, widget.chatRoomId, chatMessageMapforNotifications);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    DatabaseMethods().getConversationMessages(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
    super.initState();
  }

  void notification() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.chatRoomId
              .toString()
              .replaceAll("_", "")
              .replaceAll(Constants.myName, ""),
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            chatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
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
                        addMessage();
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

class MessageTile extends StatefulWidget {
  final String message;
  final bool sendByMe;
  final String type;

  MessageTile(
      {@required this.message, @required this.sendByMe, @required this.type});
  @override
  _MessageTileState createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  int type = 1;
  // void initiate() {
  //   if (widget.sendByMe) {
  //     type = 0;
  //   } else {
  //     if (widget.message.substring(0) ==
  //         "AIzaSyD21hwHZtifqndrAKnSa0R_CVHl_U5yWfQ") {
  //       type = 2;
  //     } else {
  //       type = 1;
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: widget.sendByMe ? 0 : 24,
          right: widget.sendByMe ? 24 : 0),
      alignment: widget.sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: widget.sendByMe
            ? EdgeInsets.only(left: 30)
            : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: widget.sendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: widget.sendByMe
                  ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                  : (widget.type == "alert"
                      ? [const Color(0xFF0000), const Color(0xFF0000)]
                      : [const Color(0xFFBBDEFB), const Color(0xFFBBDEFB)]),
            )),
        child: Text(widget.message,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: widget.sendByMe
                    ? (widget.type == "alert" ? Colors.red : Colors.white)
                    : (widget.type == "alert" ? Colors.red : Colors.black),
                fontSize: 18,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w500)),
      ),
    );
  }
}
