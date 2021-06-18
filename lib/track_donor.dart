import 'package:BOD/screens/app_drawer.dart';
import 'package:BOD/services/google_maps_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class TrackDonor extends StatefulWidget {
  final tokenid;
  const TrackDonor({Key key, this.tokenid}) : super(key: key);

  @override
  _TrackDonorState createState() => _TrackDonorState();
}

class _TrackDonorState extends State<TrackDonor> {
  var geolocator = Geolocator();
  bool locationServiceActive = true;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  static LatLng _initialPosition;

  //Controller
  GoogleMapController _mapController;
  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  Position currentPosition;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  LatLng _lastPosition;
  LatLng latLatPosition;
  void _loadingInitialPosition() async {
    await Future.delayed(Duration(seconds: 5)).then((v) {
      if (_initialPosition == null) {
        locationServiceActive = false;
      }
    });
  }

  void marker(specify, specifyid) {
    var markerIdval = specifyid;
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

  getuserInfo() {
    FirebaseFirestore.instance.collection('user').get().then((value) {
      marker(value.docs[widget.tokenid].data(), value.docs[widget.tokenid].id);
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _loadingInitialPosition();
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
                  indoorViewEnabled: true,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  markers: _markers,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: true,
                  initialCameraPosition:
                      CameraPosition(target: _initialPosition),
                  mapType: MapType.normal,
                  onMapCreated: (controller) {
                    setState(
                      () {
                        _mapController = controller;
                        double lat = 18.496790;
                        double lang = 73.855699;
                        LatLng destination = LatLng(lat, lang);
                        print(destination);
                        print(_polyLines);
                        sendRequest(destination);
                        print(_markers);
                      },
                    );
                  },
                  polylines: _polyLines,
                  onTap: (coordinate) {
                    _mapController
                        .animateCamera(CameraUpdate.newLatLng(coordinate));
                  },
                ),
              ],
            ),
          );
  }

  void onCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  void createRoute(String encondedPoly) {
    _polyLines.add(Polyline(
        polylineId: PolylineId(_lastPosition.toString()),
        width: 4,
        geodesic: true,
        visible: true,
        points: _convertToLatLng(_decodePoly(encondedPoly)),
        color: Colors.blue));
  }

  // ! CREATE LAGLNG LIST
  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  // !DECODE POLY
  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
// repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }

  void sendRequest(LatLng destination) async {
    print(_initialPosition);
    getuserInfo();
    _addMarker(destination);
    String route = await _googleMapsServices.getRouteCoordinates(
        _initialPosition, destination);
    createRoute(route);
  }

  void _getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      locationController.text = placemark[0].name;
    });
  }

  void _addMarker(LatLng destination) {
    _markers.add(Marker(
        markerId: MarkerId(_lastPosition.toString()),
        position: destination,
        infoWindow: InfoWindow(title: "", snippet: "go here"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose)));
  }
}
