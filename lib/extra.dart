import 'auth.dart';
import 'package:flutter/material.dart';
import 'authenticate.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  /*
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(45.521563, -122.677433);
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;*/

  AuthMethods authMethods = new AuthMethods();
  int _currentIndex = 1;

  /*

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  Widget button(Function function, IconData icon) {
    return FloatingActionButton(
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
      child: Icon(icon, size: 36.0),
    );
  }

  _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  Marker belgaum = Marker(
    markerId: MarkerId("Belgaum"),
    position: LatLng(15.841461, 74.512202),
    infoWindow: InfoWindow(title: "Belgaum"),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
  );

  Widget _googleMaps(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.terrain,
        initialCameraPosition:
            CameraPosition(target: LatLng(15.841461, 74.512202), zoom: 18),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: {belgaum},
      ),
    );
  }

  _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(_lastMapPosition.toString()),
          position: _lastMapPosition,
          infoWindow: InfoWindow(
            title: 'This is a title',
            snippet: 'This is a snippet',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        backgroundColor: Colors.blueAccent,
        toolbarHeight: 60,
        actions: [
          GestureDetector(
            onTap: () {},
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Image.asset("assets/notification_logo.png")),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Image.asset("assets/broadcast_logo.png")),
          ),
          GestureDetector(
            onTap: () {
              authMethods.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
      body: //SingleChildScrollView(
          Container(
        child: Column(
          children: [],
        ),
      ),
      //),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
            //backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("Team"),
            //backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            title: Text("Map"),
            //backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text("Settings"),
            // backgroundColor: Colors.blue,
          ),
        ],
        onTap: (index) {
          print(index);
          setState(() {
            _currentIndex = index;
            print(_currentIndex.toString());
          });
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/rendering.dart';
// import 'database.dart';

// class Post {
//   String userName;
//   String userEmail;

//   Post(this.userName, this.userEmail);
// }

// class Team extends StatefulWidget {
//   @override
//   _BroadcastState createState() => _BroadcastState();
// }

// class _BroadcastState extends State<Team> {
//   List<Post> posts = [];

//   void newPost(String username, String useremail) {
//     this.setState(() {
//       posts.add(new Post(username, useremail));
//     });
//   }

//   DatabaseMethods databaseMethods = new DatabaseMethods();
//   QuerySnapshot searchSnapshot;
//   QuerySnapshot searchSnapshot2;
//   TextEditingController searchTC = new TextEditingController();

//   initiateSearch() {
//     databaseMethods.getAllUsers().then((val) {
//       setState(() {
//         searchSnapshot = val;
//       });
//     });

//     for (var i = 0; i < searchSnapshot.documents.length; i++) {
//       print(searchSnapshot.documents[i].data["name"].toString());
//       print(
//         searchSnapshot.documents[i].data["email"].toString(),
//       );
//       posts.add(new Post(searchSnapshot.documents[i].data["name"].toString(),
//           searchSnapshot.documents[i].data["email"].toString()));
//     }
//   }

//   initiateSearch2() {
//     databaseMethods.getUserByUsername(searchTC.text).then((val) {
//       setState(() {
//         searchSnapshot2 = val;
//       });
//       print(searchSnapshot2.documents[0].data["name"]);
//       print(searchSnapshot2.documents[0].data["email"]);
//     });
//   }

//   Widget searchList() {
//     return searchSnapshot2 != null
//         ? ListView.builder(
//             shrinkWrap: true,
//             itemBuilder: (context, index) {
//               return SearchTile(
//                 userName: searchSnapshot2.documents[index].data["name"],
//                 userEmail: searchSnapshot2.documents[index].data["email"],
//               );
//             })
//         : Container();
//   }

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Team"),
//         backgroundColor: Colors.blue,
//         toolbarHeight: 60,
//         actions: <Widget>[
//           // Container(
//           //   padding: EdgeInsets.symmetric(horizontal: 8),
//           //   child: IconButton(
//           //     icon: Icon(
//           //       Icons.search,
//           //       color: Colors.white,
//           //       size: 30,
//           //     ),
//           //     onPressed: () {},
//           //   ),
//           // ),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 8),
//             child: IconButton(
//               icon: Icon(
//                 Icons.notifications,
//                 color: Colors.white,
//                 size: 30,
//               ),
//               onPressed: () {
//                 //initiateSearch();
//               },
//             ),
//           ),
//           Container(
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//               child: Image.asset("assets/broadcast_logo.png")),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           height: MediaQuery.of(context).size.height,
//           child: Column(
//             children: [
//               Column(
//                 children: [
//                   Container(
//                     color: Colors.grey,
//                     padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             controller: searchTC,
//                             style: TextStyle(
//                                 color: Colors.black54,
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.w600),
//                             decoration: InputDecoration(
//                               hintText: "Search username...",
//                               hintStyle: TextStyle(color: Colors.black54),
//                               border: InputBorder.none,
//                             ),
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             initiateSearch2();
//                           },
//                           child: Container(
//                             height: 40,
//                             width: 40,
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [
//                                   const Color(0x36FFFFFF),
//                                   const Color(0x0FFFFFFF),
//                                 ],
//                               ),
//                               borderRadius: BorderRadius.circular(40),
//                             ),
//                             padding: EdgeInsets.all(4),
//                             child: Icon(Icons.search, size: 30),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   searchList(),
//                 ],
//               ),
//               /*new Row(
//                 children: <Widget>[
//                   Expanded(
//                     child: SizedBox(
//                       height: MediaQuery.of(context).size.height,
//                       child: ListView.builder(
//                         itemCount: this.posts.length,
//                         itemBuilder: (context, index) {
//                           var post = this.posts[index];
//                           return Card(
//                               child: Row(
//                             //mainAxisAlignment: MainAxisAlignment.start,
//                             children: <Widget>[
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     SizedBox(
//                                       height: 4,
//                                     ),
//                                     Container(
//                                       padding:
//                                           EdgeInsets.symmetric(horizontal: 8),
//                                       child: Text(
//                                         post.userName,
//                                         style: TextStyle(
//                                           fontSize: 18,
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 3,
//                                     ),
//                                     Container(
//                                       padding:
//                                           EdgeInsets.symmetric(horizontal: 8),
//                                       child: Text(
//                                         post.userEmail,
//                                         style: TextStyle(
//                                           fontSize: 16,
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 4,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Spacer(),
//                               Container(
//                                 margin: EdgeInsets.symmetric(horizontal: 8),
//                                 decoration: BoxDecoration(
//                                   color: Colors.blue,
//                                   borderRadius: BorderRadius.circular(30),
//                                 ),
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 8, vertical: 12),
//                                 child: Text("Message"),
//                               ),
//                             ],
//                           ));
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),*/
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class SearchTile extends StatelessWidget {
//   final String userName;
//   final String userEmail;
//   SearchTile({this.userName, this.userEmail});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Row(
//         children: [
//           Column(
//             children: [
//               Text(
//                 userName,
//                 style: TextStyle(
//                   color: Colors.black54,
//                   fontSize: 18,
//                 ),
//               ),
//               Text(
//                 userEmail,
//                 style: TextStyle(
//                   color: Colors.black54,
//                   fontSize: 18,
//                 ),
//               ),
//             ],
//           ),
//           Spacer(),
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.blue,
//               borderRadius: BorderRadius.circular(30),
//             ),
//             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: Text("Message"),
//           ),
//         ],
//       ),
//     );
//   }
// }
