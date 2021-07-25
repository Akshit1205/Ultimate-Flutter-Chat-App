import 'constant.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'database.dart';

class SendAlert extends StatefulWidget {
  final String username;
  SendAlert(this.username);

  @override
  _SendAlertState createState() => _SendAlertState();
}

class _SendAlertState extends State<SendAlert> {
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

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
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

  createChatroomAndStartConversation(String username) {
    if (username != Constants.myName) {
      String chatroomID = getChatRoomId(username, Constants.myName);

      List<String> users = [username, Constants.myName];
      Map<String, dynamic> chatroomMap = {
        "users": users,
        "chatroomID": chatroomID
      };

      databaseMethods.createChatRoom(chatroomID, chatroomMap);
    }
  }

  addAlert() {
    if (textTC.text.isNotEmpty) {
      createChatroomAndStartConversation(widget.username);
      String chatRoomId = getChatRoomId(widget.username, Constants.myName);

      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myName,
        "message": textTC.text,
        'time': DateTime.now().millisecondsSinceEpoch,
        "type": "alert",
      };

      String sendByuser = widget.username;
      DatabaseMethods().addConversationMessages(chatRoomId, chatMessageMap);

      Map<String, dynamic> chatMessageMapforNotifications = {
        "sendBy": Constants.myName,
        "message": textTC.text,
        'time': DateTime.now().millisecondsSinceEpoch,
        "id": chatRoomId,
        "type": "alert",
      };
      DatabaseMethods().addAlerts(
          sendByuser, Constants.myName, chatMessageMapforNotifications);

      setState(() {
        textTC.text = "";
      });
    }
  }

  createGroup() {
    // initiateSearch();
    // Map<String, dynamic> groupchatInfoMap = {
    //   "chatroomID": textTC.text.toString(),
    // };

    // Map<String, dynamic> userInfoMap = {
    //   "name": Constants.myName,
    //   "email": userEmail,
    //   "admin": true,
    //   "superadmin": true,
    // };

    // databaseMethods.createGroupChatRoom(
    //     textTC.text.toString(), groupchatInfoMap);

    // databaseMethods.addUsertoGroup(
    //     textTC.text.toString(), userInfoMap, Constants.myName);
    // databaseMethods.addGroupToUser(groupchatInfoMap, Constants.myName);

    // userEmail = "";

    // setState(() {
    //   textTC.text = "";
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Send Alert"),
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
                    hintText: "Type your alert...",
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
                  addAlert();
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
