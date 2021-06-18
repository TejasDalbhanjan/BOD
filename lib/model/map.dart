import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../screens/app_drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Mapp extends StatefulWidget {
  @override
  GmapState createState() => GmapState();
}

class GmapState extends State<Mapp> {
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  GoogleMapController _mapController;
  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  var geolocator = Geolocator();
  Position currentPosition;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  LatLng latLatPosition;
  static LatLng _initialPosition;

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

  void initHospitalMarker(specify, specifyId) async {
    var markerIdval = specifyId;
    final MarkerId markerId = MarkerId(markerIdval);
    final Marker marker = Marker(
      markerId: markerId,
      position:
          LatLng(specify['location'].latitude, specify['location'].longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      infoWindow: InfoWindow(
        title: specify['name'],
        snippet: specify['Licence_No'],
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
    FirebaseFirestore.instance.collection('hospital').get().then((value) {
      if (value.docs.isNotEmpty) {
        for (int i = 0; i < value.docs.length; i++) {
          initHospitalMarker(value.docs[i].data(), value.docs[i].id);
        }
      }
    });
  }

  @override
  void initState() {
    getMarkerData();
    super.initState();
    locateCurrentPosition();
  }

  void locateCurrentPosition() async {
    Position position = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    currentPosition = position;
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      locationController.text = placemark[0].name;
    });
    latLatPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        new CameraPosition(target: latLatPosition, zoom: 14);

    _mapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  Widget build(BuildContext context) {
    return _initialPosition == null
        ? Container(
            alignment: Alignment.center,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('Home'),
              backgroundColor: Colors.red,
            ),
            drawer: ADrawer(),
            body: Stack(
              children: [
                GoogleMap(
                    polylines: _polyLines,
                    indoorViewEnabled: true,
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    zoomGesturesEnabled: true,
                    markers: Set<Marker>.of(markers.values),
                    zoomControlsEnabled: true,
                    initialCameraPosition:
                        CameraPosition(target: _initialPosition),
                    mapType: MapType.normal,
                    onMapCreated: (controller) {
                      setState(() {
                        _mapController = controller;
                        locateCurrentPosition();
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
