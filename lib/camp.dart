import 'dart:async';

import 'package:BOD/places.dart';
import 'package:BOD/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'db.dart';

class DateTimePickerWidget extends StatefulWidget {
  @override
  _DateTimePickerWidgetState createState() => _DateTimePickerWidgetState();
}

class _DateTimePickerWidgetState extends State<DateTimePickerWidget> {
  DateTime selectedDate = DateTime.now();
  final _scrollController = ScrollController();
  String locationMessage;
  String lat;
  String long;
  TextEditingController dateTime = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  Position _position;
  Address _address;
  String _path;
  TextEditingController _controller = TextEditingController();

  String _add;
  String _extension;
  StreamSubscription<Position> _streamSubscription;

  final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');
  void getCurrentLocation() async {
    final position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      locationMessage = "${position.latitude}, ${position.longitude}";
      lat = position.latitude.toString();
      long = position.longitude.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);

    var locationOption =
        LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 1);
    _streamSubscription = Geolocator()
        .getPositionStream(locationOption)
        .listen((Position position) {
      setState(() {
        _position = position;

        final coordinates =
            new Coordinates(position.latitude, position.longitude);
        convertCotoAdd(coordinates).then((value) => _address = value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: Text('CAMP REGISTRATION'),
        backgroundColor: Colors.red,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Text(
              "Donation Camp Registration",
              style: TextStyle(
                  fontSize: 25,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 40),
          Text(
            "Search for Location -",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          SearchInjector(
            child: SafeArea(
              child: Consumer<LocationApi>(
                builder: (_, api, child) => SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          child: TextField(
                            controller: api.addressController,
                            decoration: InputDecoration(
                              labelText: "Search".tr(),
                              border: OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.red),
                              ),
                              prefixIcon: Icon(Icons.location_pin),
                            ),
                            onChanged: api.handleSearch,
                          ),
                        ),
                        Container(
                          color: Colors.blue[100].withOpacity(.3),
                          width: MediaQuery.of(context).size.width,
                          height: 150,
                          child: StreamBuilder<List<Place>>(
                              stream: api.controllerOut,
                              builder: (context, snapshot) {
                                if (snapshot.data == null) {
                                  return Center(
                                      child: Text('No data address found'));
                                }
                                final data = snapshot.data;

                                return Scrollbar(
                                  controller: _scrollController,
                                  child: SingleChildScrollView(
                                    controller: _scrollController,
                                    child: Container(
                                      child: Builder(builder: (context) {
                                        return Column(
                                            children: List.generate(data.length,
                                                (index) {
                                          final place = data[index];
                                          return ListTile(
                                            onTap: () {
                                              setState(() {
                                                api.addressController.text =
                                                    '${place.name}, ${place.locality}';
                                                print(
                                                    api.addressController.text);
                                              });
                                            },
                                            title: Text(
                                                '${place.name},${place.street}'),
                                            subtitle: Text(
                                                '${place.locality},${place.country}'),
                                          );
                                        }));
                                      }),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: InkWell(
              radius: 10,
              onTap: () {
                getCurrentLocation();
                String _add = "${_address?.addressLine}";
                Text(_add);
              },
              child: Text(
                "Current location",
                style: TextStyle(
                  fontSize: 15,
                  decoration: TextDecoration.underline,
                  color: Colors.red,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 35,
          ),
          Text(
            "Select Date/Time -",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          Text(dateFormat.format(selectedDate)),
          Center(
            child: RaisedButton(
              child: Text('Choose date time'),
              onPressed: () async {
                final selectedDate = await _selectDateTime(context);
                if (selectedDate == null) return;

                print(selectedDate);

                final selectedTime = await _selectTime(context);
                if (selectedTime == null) return;
                print(selectedTime);

                setState(() {
                  this.selectedDate = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );
                });
              },
            ),
          ),
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
            height: 50,
            child: MaterialButton(
              onPressed: () async {
                await createcamp();
              },
              color: Colors.red,
              highlightColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.white),
              ),
              elevation: 8.0,
              child: Center(
                child: Text(
                  'DONE',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<TimeOfDay> _selectTime(BuildContext context) {
    final now = DateTime.now();

    return showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
    );
  }

  Future<DateTime> _selectDateTime(BuildContext context) => showDatePicker(
        context: context,
        initialDate: DateTime.now().add(Duration(seconds: 1)),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );

  Future<Address> convertCotoAdd(Coordinates coordinates) async {
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return addresses.first;
  }

  Future createcamp() async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    final id = _auth.currentUser.uid;
    DocumentSnapshot document =
        await FirebaseFirestore.instance.collection('hospital').doc(id).get();
    String name = document[id].data(['name']);

    await Db().createCampdata(name, _add, selectedDate, id);
  }
}

class SearchInjector extends StatelessWidget {
  final Widget child;

  const SearchInjector({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocationApi(),
      child: child,
    );
  }
}
