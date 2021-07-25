import 'package:finalflutter/bottom_team.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'database.dart';
import 'broadcast.dart';
import 'constant.dart';
import 'conservationscreen.dart';
import 'groupchat.dart';
import 'diffgroups.dart';
import 'alert_notification.dart';
import 'authenticate.dart';
import 'auth.dart';
import 'notification.dart';
import 'constant.dart';

class Chat extends StatefulWidget {
  @override
  _BroadcastState createState() => _BroadcastState();
}

class _BroadcastState extends State<Chat> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  AuthMethods authMethods = new AuthMethods();
  QuerySnapshot searchSnapshot2;
  TextEditingController searchTC = new TextEditingController();

  Stream chatroomStream;
  Stream grpchatroomStream;

  void initiateSearch() {
    databaseMethods.getChatRooms(Constants.myName).then((value) {
      setState(() {
        chatroomStream = value;
      });
    });
  }

  void initState() {
    initiateSearch();
    super.initState();
  }

  initiateSearch2() {
    databaseMethods.getUserByUsername(searchTC.text).then((val) {
      setState(() {
        searchSnapshot2 = val;
      });
    });
  }

  Widget searchList() {
    return searchSnapshot2 != null && searchTC.text != Constants.myName
        ? ListView.builder(
            itemCount: searchSnapshot2.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return searchtile(
                searchSnapshot2.documents[index].data["name"],
                searchSnapshot2.documents[index].data["email"],
              );
            })
        : Container();
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
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConservationScreen(chatroomID)));
    }
  }

  Widget searchtile(String userName, String userEmail) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: Colors.black,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              Text(
                userEmail,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatroomAndStartConversation(userName);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                "Message",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "   Hey " + Constants.myName,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        //backgroundColor: Colors.blue,
        toolbarHeight: 80,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Notifications()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                child: Image.asset("assets/notification_logo.png")),
          ),

          // Container(
          //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          //     child: Image.asset("assets/chaticon.png")),

          GestureDetector(
            onTap: () {
              authMethods.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              child: Icon(Icons.exit_to_app),
            ),
          ),
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 8),
          //   child: IconButton(
          //     icon: Icon(
          //       Icons.notifications,
          //       color: Colors.white,
          //       size: 30,
          //     ),
          //     onPressed: () {},
          //   ),
          // ),
          // Container(
          //     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          //     child: GestureDetector(
          //       onTap: () {
          //         Navigator.push(context,
          //             MaterialPageRoute(builder: (context) => Broadcast()));
          //       },
          //       child: Image.asset("assets/broadcast_logo.png"),
          //     )),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height + 80,
          child: Column(
            children: [
              Column(
                children: [
                  // Container(
                  //   color: Colors.grey,
                  //   padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: TextField(
                  //           controller: searchTC,
                  //           style: TextStyle(
                  //               color: Colors.white,
                  //               fontSize: 20,
                  //               fontWeight: FontWeight.w600),
                  //           decoration: InputDecoration(
                  //             hintText: "Search username...",
                  //             hintStyle: TextStyle(color: Colors.white54),
                  //             border: InputBorder.none,
                  //           ),
                  //         ),
                  //       ),
                  //       GestureDetector(
                  //         onTap: () {
                  //           initiateSearch2();
                  //           setState(() {
                  //             // _visibile = !_visibile;
                  //           });
                  //         },
                  //         child: Container(
                  //           height: 40,
                  //           width: 40,
                  //           decoration: BoxDecoration(
                  //             gradient: LinearGradient(
                  //               colors: [
                  //                 const Color(0x36FFFFFF),
                  //                 const Color(0x0FFFFFFF),
                  //               ],
                  //             ),
                  //             borderRadius: BorderRadius.circular(40),
                  //           ),
                  //           padding: EdgeInsets.all(4),
                  //           child: Icon(Icons.search, size: 30),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Groups()));
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                      color: Colors.black,
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(vertical: 2),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Your GroupChats",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  searchList(),
                ],
              ),
              new Row(
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
                                    return ChatRoomTile(
                                        snapshot.data.documents[index]
                                            .data["chatroomID"]
                                            .toString()
                                            .replaceAll("_", "")
                                            .replaceAll(Constants.myName, ""),
                                        snapshot.data.documents[index]
                                            .data["chatroomID"]);
                                  },
                                )
                              : Container();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Team()));
        },
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String username;
  final String chatroomID;
  ChatRoomTile(this.username, this.chatroomID);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConservationScreen(chatroomID)));
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
            Text(
              username,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            )
          ],
        ),
      ),
    );
  }
}
