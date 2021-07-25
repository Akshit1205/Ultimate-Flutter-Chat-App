import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(31.5892, 76.9182);

  final Set<Marker> _markers = {};

  LatLng _lastMapPosition = _center;

  MapType _currentMapType = MapType.normal;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: 'Really cool place',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Map View"),
      ),
      body: Stack(children: <Widget>[
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.topRight,
            child: Column(children: <Widget>[
              FloatingActionButton(
                onPressed: () => print('button pressed'),
                materialTapTargetSize: MaterialTapTargetSize.padded,
                backgroundColor: Colors.green,
                child: const Icon(Icons.map, size: 36.0),
              ),
              SizedBox(
                height: 16.0,
              ),
              // FloatingActionButton(
              //   onPressed: _onAddMarkerButtonPressed,
              //   materialTapTargetSize: MaterialTapTargetSize.padded,
              //   backgroundColor: Colors.green,
              //   child: Icon(Icons.add_location, size: 36.0),
              // ),
            ]),
          ),
        ),
      ]),
    );
  }
}

/*
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutterapp/google_place_util.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> implements GooglePlacesListener {
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  Position _currentPosition;
  String locationAddress = "Search destination";
  GooglePlaces googlePlaces;
  double _destinationLat;
  double _destinationLng;

  Completer<GoogleMapController> _controller = Completer();

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(0, 0),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    googlePlaces = GooglePlaces(this);
    _getCurrentLocation();
  }

  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _updatePosition(_currentPosition);
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> _updatePosition(Position currentPosition) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(currentPosition.latitude, currentPosition.longitude),
      zoom: 14.4746,
    )));
    googlePlaces.updateLocation(
        currentPosition.latitude, currentPosition.longitude);
  }

  @override
  Widget build(BuildContext context) {
    var screenWidget = Stack(
      children: <Widget>[
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          myLocationEnabled: true,
          polylines: Set<Polyline>.of(polylines.values),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
        GestureDetector(
          onTap: () {
            googlePlaces.findPlace(context);
          },
          child: Container(
            height: 50.0,
            alignment: FractionalOffset.center,
            margin: EdgeInsets.all(10.0),
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(255, 255, 255, 1.0),
              border: Border.all(color: const Color(0x33A6A6A6)),
              borderRadius: BorderRadius.all(const Radius.circular(6.0)),
            ),
            child: Row(
              children: <Widget>[
                Icon(Icons.search),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.only(right: 13.0),
                    child: Text(
                      locationAddress,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: const Color(0xFFA6AFAA),
      appBar: AppBar(
        title: Text(
          "Google maps route",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: screenWidget,
    );
  }

  @override
  selectedLocation(double lat, double lng, String address) {
    setState(() {
      _destinationLat = lat;
      _destinationLng = lng;
      locationAddress = address;
    });
    _getPolyline();
  }

  _addPolyLine() {
    polylines.clear();
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "GOOGLE_KEY",
        PointLatLng(_currentPosition.latitude, _currentPosition.longitude),
        PointLatLng(_destinationLat, _destinationLng),
        travelMode: TravelMode.driving);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }
}
*/
