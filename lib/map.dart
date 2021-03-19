import 'package:flutter/material.dart';
import 'appD.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Mapp extends StatefulWidget {
  @override
  GmapState createState() => GmapState();
}

class GmapState extends State<Mapp> {
  GoogleMapController _mapController;
  var geolocator = Geolocator();
  Position currentPosition;

  LatLng latLatPosition;

  static final CameraPosition _initialPosition =
      CameraPosition(target: LatLng(18.5204, 73.8567));

  void locateP() async {
    Position position = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    latLatPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        new CameraPosition(target: latLatPosition, zoom: 14);

    _mapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.red,
      ),
      drawer: ADrawer(),
      body: GoogleMap(
          mapToolbarEnabled: true,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: true,
          initialCameraPosition: _initialPosition,
          mapType: MapType.normal,
          onMapCreated: (controller) {
            setState(() {
              _mapController = controller;
              locateP();
            });
          },
          onTap: (coordinate) {
            _mapController.animateCamera(CameraUpdate.newLatLng(coordinate));
          }),
    );
  }
}

/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';

class Mapp extends StatefulWidget {
  @override
  GmapState createState() => GmapState();
}

class GmapState extends State<Mapp> {
  CameraPosition _initalPosition =
      CameraPosition(target: LatLng(18.508226, 73.863677), zoom: 14.0);
  final List<Marker> markers1 = [];
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  addMarker(cordinate) {
    int id = Random().nextInt(100);

    setState(() {
      markers1
          .add(Marker(position: cordinate, markerId: MarkerId(id.toString())));
    });
  }

  GoogleMapController _controller;

  void initMarker(specify, specifyId) async {
    var markerIdval = specifyId;
    final MarkerId markerId = MarkerId(markerIdval);
    final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(specify['Co-ordinates'].latitude,
            specify['Co-ordinates'].longitude),
        infoWindow:
            InfoWindow(title: 'shop', snippet: specify['Co-ordinates']));

    setState(() {
      markers[markerId] = marker;
    });
  }

  getMarkerdata() async {
    FirebaseFirestore.instance.collection('user').get().then((mydata) {
      if (mydata.docs.isNotEmpty) {
        for (int i = 0; i < mydata.docs.length; i++) {
          initMarker(mydata.docs[i].data(), mydata.docs[i].id);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        initialCameraPosition: _initalPosition,
        mapType: MapType.normal,
        mapToolbarEnabled: true,
        onMapCreated: (controller) {
          setState(() {
            _controller = controller;
          });
        },
        markers: Set<Marker>.of(markers.values),
        onTap: (cordinate) {
          _controller.animateCamera(CameraUpdate.newLatLng(cordinate));
          addMarker(cordinate);
        },
      ),
    );
  }
}*/
