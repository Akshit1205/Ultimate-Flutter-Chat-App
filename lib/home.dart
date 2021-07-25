import 'auth.dart';
import 'conservationscreen.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'authenticate.dart';
import 'broadcast.dart';
import 'bottom_team.dart';
import 'constant.dart';
import 'helper.dart';
import 'mapview.dart';
import 'chat.dart';
import 'notification.dart';
import 'groupchat.dart';
import 'diffgroups.dart';
import 'alert_notification.dart';

class Extra extends StatefulWidget {
  @override
  _ExtraState createState() => _ExtraState();
}

class _ExtraState extends State<Extra> {
  AuthMethods authMethods = new AuthMethods();
  int _currentindex = 0;

  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(45.521563, -122.677433);

  final Set<Marker> _markers = {};

  @override
  void initState() {
    if (Constants.fromSignUp) {
      getUserInfo();
    }
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    setState(() {});
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void Display() {
    for (var i = 0; i < Constants.arr.length; i++) {
      print(Constants.arr[i].useremail);
      print(Constants.arr[i].password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello " + Constants.myName),
        backgroundColor: Colors.blue,
        toolbarHeight: 60,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Alerts()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Image.asset("assets/notification_logo.png")),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Broadcast()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Image.asset(
                  "assets/broadcast_logo.png",
                )),
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
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                width: 500,
                height: 70,
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.lightBlue,
                    width: 3,
                  ),
                ),
                child: RichText(
                  text: TextSpan(
                    text: "Hello " + Constants.myName,
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              // Container(
              //   alignment: Alignment.center,
              //   width: 500,
              //   height: 150,
              //   margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              //   padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(30),
              //     border: Border.all(
              //       color: Colors.lightBlue,
              //       width: 3,
              //     ),
              //   ),
              //   child: RichText(
              //     text: TextSpan(
              //       text:
              //           'Your team..                      Your role..                    Team Leader..',
              //       style: TextStyle(color: Colors.white, fontSize: 30),
              //     ),
              //   ),
              // ),
              // Container(
              //   child: GoogleMap(
              //     onMapCreated: _onMapCreated,
              //     initialCameraPosition: CameraPosition(
              //       target: _center,
              //       zoom: 11.0,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentindex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("Team"),
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            title: Text("Map"),
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text("Settings"),
            backgroundColor: Colors.blue,
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentindex = index;
            if (index == 1) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Team()));
            } else if (index == 2) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Map()));
            } else if (index == 3) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Chat()));
            }
          });
        },
      ),
    );
  }
}
