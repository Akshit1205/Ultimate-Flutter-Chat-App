import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'database.dart';
import 'broadcast.dart';
import 'constant.dart';
import 'conservationscreen.dart';
import 'groupchat.dart';
import 'creategroup.dart';
import 'alert.dart';

class Groups extends StatefulWidget {
  @override
  _BroadcastState createState() => _BroadcastState();
}

class _BroadcastState extends State<Groups> {
  bool _visibile = true;
  bool isPresent = false;
  String dropdownValue = 'One';

  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot searchSnapshot;
  QuerySnapshot searchSnapshot2;
  TextEditingController searchTC = new TextEditingController();
  Stream chatroomStream;

  @override
  void initState() {
    initiateSearch();
    super.initState();
  }

  bool isPresentInGroup(String groupname) {
    databaseMethods.usersPresentInGroup(groupname).then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });

    if (searchSnapshot != null) {
      for (var i = 0; i < searchSnapshot.documents.length; i++) {
        if (Constants.myName ==
            searchSnapshot.documents[i].data["name"].toString()) {
          return true;
        }
      }
      return false;
    }
  }

  initiateSearch() {
    databaseMethods.groupsPresentForUser(Constants.myName).then((val) {
      setState(() {
        chatroomStream = val;
        //val.data.documents[0].data["chatroomID"].toString();
      });
    });

    //  if (searchSnapshot != null) {
    //   for (var i = 0; i < searchSnapshot.documents.length; i++) {
    //     print(searchSnapshot.documents[i].data["name"].toString());
    //     print(
    //       searchSnapshot.documents[i].data["email"].toString(),
    //     );
    //     posts.add(new Post(searchSnapshot.documents[i].data["name"].toString(),
    //         searchSnapshot.documents[i].data["email"].toString()));
    //   }
    // }
  }

  initiateSearch2() {
    databaseMethods
        .getGroupByGroupname(searchTC.text, Constants.myName)
        .then((val) {
      setState(() {
        searchSnapshot2 = val;
      });
      //print(searchSnapshot2.documents[0].data["name"]);
      //print(searchSnapshot2.documents[0].data["email"]);
    });
  }

  Widget searchList() {
    return searchSnapshot2 != null && searchTC.text != Constants.myName
        ? ListView.builder(
            itemCount: searchSnapshot2.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              //Constants.myName = searchSnapshot2.documents[index].data["name"];
              return searchtile(
                searchSnapshot2.documents[index].data["chatroomID"],
                // searchSnapshot2.documents[index].data["email"],
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

  Widget searchtile(String groupname) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: Colors.black,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                groupname,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              // Text(
              //   userEmail,
              //   style: TextStyle(
              //     color: Colors.white,
              //     fontSize: 18,
              //   ),
              // ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GroupConversation(groupname)));
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                "Message",
                style: TextStyle(fontSize: 18, color: Colors.white),
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

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Groups"),
        toolbarHeight: 60,
        actions: <Widget>[
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 8),
          //   child: IconButton(
          //     icon: Icon(
          //       Icons.notifications,
          //       color: Colors.white,
          //       size: 30,
          //     ),
          //     onPressed: () {
          //       // Navigator.push(context,
          //       //     MaterialPageRoute(builder: (context) => CreateGroup()));
          //     },
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
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButton<String>(
              value: dropdownValue,
              icon: Image.asset("assets/3dot.png"),
              iconSize: 16,
              elevation: 16,
              dropdownColor: Colors.black,
              style: TextStyle(color: Colors.white, fontSize: 18),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                  if (newValue == "New") {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CreateGroup()));
                  }
                  // if (newValue == "Alert") {
                  //   Navigator.push(context,
                  //       MaterialPageRoute(builder: (context) => Alert()));
                  // }
                });
              },
              items: <String>['One', 'Two', 'Three', 'New']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height + 80,
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    color: Colors.grey,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchTC,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                              hintText: "Search groupname...",
                              hintStyle: TextStyle(color: Colors.white54),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            initiateSearch2();
                            setState(() {
                              // _visibile = !_visibile;
                            });
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0x36FFFFFF),
                                  const Color(0x0FFFFFFF),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            padding: EdgeInsets.all(4),
                            child: Icon(Icons.search, size: 30),
                          ),
                        ),
                      ],
                    ),
                  ),
                  searchList(),
                ],
              ),
              Visibility(
                visible: _visibile,
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
                                      return
                                          //isPresentInGroup(snapshot
                                          //         .data
                                          //         .documents[index]
                                          //         .data["chatroomID"]
                                          //         .toString())
                                          ChatRoomTile(snapshot
                                              .data
                                              .documents[index]
                                              .data["chatroomID"]
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
  final String groupname;
  ChatRoomTile(this.groupname);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GroupConversation(groupname)));
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
                "${groupname.substring(0, 1).toUpperCase()}",
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
                    groupname,
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
