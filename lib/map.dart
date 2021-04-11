import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'appD.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Mapp extends StatefulWidget {
  @override
  GmapState createState() => GmapState();
}

class GmapState extends State<Mapp> {
  Set<Marker> _markers = {};
  GoogleMapController _mapController;
  var geolocator = Geolocator();
  Position currentPosition;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  LatLng latLatPosition;
  static final CameraPosition _initialPosition =
      CameraPosition(target: LatLng(18.5204, 73.8567));

  void initMarker(specify, specifyId) async {
    var markerIdval = specifyId;
    final MarkerId markerId = MarkerId(markerIdval);
    final Marker marker = Marker(
      markerId: markerId,
      position:
          LatLng(specify['location'].latitude, specify['location'].longitude),
      infoWindow: InfoWindow(
        title: specify['Blood-Group'],
        snippet: specify['name'],
      ),
      zIndex: 20,
      draggable: false,
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  getMarkerData() async {
    FirebaseFirestore.instance.collection('user').get().then((value) {
      if (value.docs.isNotEmpty) {
        for (int i = 0; i < value.docs.length; i++) {
          initMarker(value.docs[i].data(), value.docs[i].id);
        }
      }
    });
  }

  @override
  void initState() {
    print("Hello");
    getMarkerData();
    super.initState();
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.red,
      ),
      drawer: ADrawer(),
      body: Stack(
        children: [
          GoogleMap(
              indoorViewEnabled: true,
              mapToolbarEnabled: true,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              markers: Set<Marker>.of(markers.values),
              zoomControlsEnabled: true,
              initialCameraPosition: _initialPosition,
              mapType: MapType.normal,
              onMapCreated: (controller) {
                setState(() {
                  _mapController = controller;
                  locateP();
                  print(_markers);
                });
              },
              onTap: (coordinate) {
                _mapController
                    .animateCamera(CameraUpdate.newLatLng(coordinate));
              }),
        ],
      ),
    );
  }
}
