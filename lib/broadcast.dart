import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'database.dart';
import 'bottom_team.dart';
import 'constant.dart';

class Post {
  String userName;
  String userEmail;

  Post(this.userName, this.userEmail);
}

class Broadcast extends StatefulWidget {
  @override
  _BroadcastState createState() => _BroadcastState();
}

class _BroadcastState extends State<Broadcast> {
  List<Post> posts = [];

  void newPost(String username, String useremail) {
    this.setState(() {
      posts.add(new Post(username, useremail));
    });
  }

  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot searchSnapshot;
  TextEditingController messageEditingController = new TextEditingController();
  Stream chatroomStream;

  initiateSearch() {
    databaseMethods.getAllUsersSnapshot().then((val) {
      setState(() {
        chatroomStream = val;
      });
    });

    // for (var i = 0; i < searchSnapshot.documents.length; i++) {
    //   print(searchSnapshot.documents[i].data["name"].toString());
    //   print(
    //     searchSnapshot.documents[i].data["email"].toString(),
    //   );
    //   posts.add(new Post(searchSnapshot.documents[i].data["name"].toString(),
    //       searchSnapshot.documents[i].data["email"].toString()));
    // }
  }

  addMessage(chatRoomId) {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myName,
        "message": messageEditingController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseMethods().addConversationMessages(chatRoomId, chatMessageMap);
      Map<String, dynamic> chatMessageMapforNotifications = {
        "sendBy": Constants.myName,
        "message": messageEditingController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
        "id": chatRoomId,
        "type": "individual",
      };

      String sendByuser = chatRoomId
          .toString()
          .replaceAll("_", "")
          .replaceAll(Constants.myName, "");
      DatabaseMethods().addNotifications(
          sendByuser, chatRoomId, chatMessageMapforNotifications);
      setState(() {
        //messageEditingController.text = "";
      });
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
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => ConservationScreen(chatroomID)));
    }
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    initiateSearch2();
    initiateSearch();
    super.initState();
  }

  initiateSearch2() {
    databaseMethods.getAllUsers().then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  broadcast() {
    if (searchSnapshot != null) {
      for (var i = 0; i < searchSnapshot.documents.length; i++) {
        String username = searchSnapshot.documents[i].data["name"].toString();
        print(username);
        createChatroomAndStartConversation(username);
        if (username != Constants.myName) {
          String chatroomID = getChatRoomId(username, Constants.myName);
          addMessage(chatroomID);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BroadCast"),
        backgroundColor: Colors.blue,
        toolbarHeight: 60,
        actions: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: IconButton(
              icon: Icon(
                Icons.notifications,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                //initiateSearch();
              },
            ),
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: GestureDetector(
                onTap: () {
                  //Navigator.push(context,
                  //  MaterialPageRoute(builder: (context) => Broadcast()));
                },
                child: Image.asset("assets/broadcast_logo.png"),
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height + 50,
          child: Column(
            children: [
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
                          fontSize: 20,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                            hintText: "Type your message ...",
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                            border: InputBorder.none),
                      )),
                      SizedBox(
                        width: 16,
                      ),
                      GestureDetector(
                        onTap: () {
                          broadcast();
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
              Visibility(
                //visible: _visibile,
                child: new Row(
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
                                          snapshot.data.documents[index]
                                              .data["name"]
                                              .toString(),
                                          snapshot.data.documents[index]
                                              .data["email"]
                                              .toString());
                                    },
                                  )
                                : Container();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String username;
  final String useremail;
  ChatRoomTile(this.username, this.useremail);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => ConservationScreen(chatroomID)));
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
                "${username.substring(0, 1).toUpperCase()}",
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
                    username,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    useremail,
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
