import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:geolocator/geolocator.dart';
import 'db.dart';
import 'dart:async';
import 'homepage.dart';

const kGoogleApiKey = "AIzaSyDbtEjg1C6-43fkzRdPq406uYSJGaBMExI";

class Donorf extends StatefulWidget {
  @override
  State createState() => DonorfState();
}

class DonorfState extends State<Donorf> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _displayName = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _confirmpassController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _adharController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  String _errorpass;
  Position _position;
  Address _address;
  StreamSubscription<Position> _streamSubscription;

  String _fileName;
  String _path;
  String _extension;
  Map<String, String> _paths;
  bool _loadingPath = false;
  bool _multiPick = false;
  bool _hasValidMime = false;
  FileType _pickingType;
  TextEditingController _controller = TextEditingController();
  LatLng coordinates;
  String _add;
  String locationMessage = "";
  void getCurrentLocation() async {
    final position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      locationMessage = "${position.latitude}, ${position.longitude}";
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
        print(position);
        _position = position;
        final coordinates =
            new Coordinates(position.latitude, position.longitude);
        convertCotoAdd(coordinates).then((value) => _address = value);
      });
    });
  }

  void openFileExplorer() async {
    try {
      _path = null;
      if (_multiPick) {
        _paths = await FilePicker.getMultiFilePath(
            type: _pickingType, allowedExtensions: [_extension]);
      } else {
        _path = await FilePicker.getFilePath(
            type: _pickingType, allowedExtensions: [_extension]);
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    return Scaffold(
        key: _scaffoldkey,
        appBar:
            AppBar(title: Text("DetailsOD").tr(), backgroundColor: Colors.red),
        //resizeToAvoidBottomPadding: false,
        body: Form(
          key: _formKey,
          child: Container(
            child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                reverse: true,
                child: new Stack(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Image(
                        image: AssetImage("assets/logo.jpg"),
                        fit: BoxFit.fill,
                        color: Colors.black12,
                        colorBlendMode: BlendMode.colorBurn,
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                                child: TextFormField(
                                  controller: _displayName,
                                  decoration: InputDecoration(
                                      labelText: 'name'.tr(),
                                      labelStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      )),
                                  validator: (value) {
                                    if (value.isEmpty || value.length >= 8) {
                                      return 'Enter full name!';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.name,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty ||
                                        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z]+\.[a-zA-Z]+")
                                            .hasMatch(value)) {
                                      return 'Enter a valid email!';
                                    }
                                    return null;
                                  },
                                  controller: _emailController,
                                  textInputAction: TextInputAction.next,
                                  onEditingComplete: () => node.nextFocus(),
                                  decoration: InputDecoration(
                                      labelText: 'Email_id'.tr(),
                                      labelStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      )),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                                child: TextFormField(
                                  onTap: () async {
                                    print("Succesfull");

                                    Prediction p =
                                        await PlacesAutocomplete.show(
                                            context: context,
                                            apiKey: kGoogleApiKey,
                                            mode: Mode
                                                .fullscreen, // Mode.fullscreen
                                            language: "fr",
                                            components: [
                                          new Component(Component.country, "fr")
                                        ]);
                                    displayPrediction(
                                        p, _scaffoldkey.currentState);
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Enter address!';
                                    }
                                    return null;
                                  },
                                  initialValue: _add,
                                  decoration: InputDecoration(
                                    alignLabelWithHint: true,
                                    //hintText: "${_address?.addressLine}",
                                    labelText: 'Ad'.tr(),

                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  keyboardType: TextInputType.multiline,
                                ),
                              ),

                              Container(
                                padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty || value.length != 12) {
                                      return 'Enter adharcard number!';
                                    }
                                    return null;
                                  },
                                  controller: _adharController,
                                  textInputAction: TextInputAction.next,
                                  onEditingComplete: () => node.nextFocus(),
                                  decoration: InputDecoration(
                                      labelText: 'Adharn'.tr(),
                                      labelStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      )),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              // SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Enter age!';
                                    }
                                    return null;
                                  },
                                  controller: _ageController,
                                  decoration: InputDecoration(
                                      labelText: 'Age'.tr(),
                                      labelStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      )),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                                child: TextFormField(
                                  controller: _passController,
                                  validator: (value) {
                                    if (value.isEmpty || value.length < 8) {
                                      return 'Enter Valid password !';
                                    }
                                    return null;
                                  },
                                  textInputAction: TextInputAction.next,
                                  onEditingComplete: () => node.nextFocus(),
                                  decoration: InputDecoration(
                                    labelText: 'Password'.tr(),
                                    labelStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  obscureText: true,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                                child: TextFormField(
                                  controller: _confirmpassController,
                                  textInputAction: TextInputAction.next,
                                  onEditingComplete: () => node.nextFocus(),
                                  validator: (String val) {
                                    if (val != _passController.text)
                                      return "Invalid Password";
                                    else
                                      return null;
                                  },
                                  decoration: InputDecoration(
                                    errorText: _errorpass,
                                    labelText: 'ConfirmP'.tr(),
                                    labelStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  obscureText: true,
                                ),
                              ),

                              Container(
                                padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                                child: Row(
                                  children: [
                                    Text(
                                      'HealthH',
                                      semanticsLabel: "Upload Image",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            child: IconButton(
                                                icon: Icon(
                                                    Icons.add_a_photo_outlined),
                                                onPressed: () async {
                                                  openFileExplorer();
                                                }),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 30),

                              Container(
                                  padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        FlatButton(
                                            onPressed: () {
                                              getCurrentLocation();
                                              _add = "${_address?.addressLine}";
                                              print(_add);
                                            },
                                            color: Colors.green,
                                            child: Text(
                                                "Pick Your Current Location as Home Address"))
                                      ])),

                              SizedBox(height: 30),
                              Container(
                                height: 50,
                                child: MaterialButton(
                                  onPressed: () async {
                                    if (true) {
                                      _registerAccount();
                                    }
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
                                      'Donate',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ).tr(),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ])),
          ),
        ));
  }

  GlobalKey<FormState> buildFormKey() => _formKey;

  Future _registerAccount() async {
    String name = _displayName.text;
    String email1 = _emailController.text;
    String adhar = _adharController.text;
    String age = _ageController.text;
    String add;
    if (_addController.text.isNotEmpty || _addController.text.length >= 8) {
      add = _addController.text;
    } else {
      add = _add;
    }
    print("On Register account");
    try {
      UserCredential result = (await _auth.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passController.text));
      User user = result.user;

      if (user != null) {
        if (!user.emailVerified) {
          await user.sendEmailVerification();
        }

        await Db().createUserData(
          name,
          email1,
          add,
          age,
          adhar,
          locationMessage,
          user.uid,
        );

        final user1 = _auth.currentUser;
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => BottomNB(user: user1)));
        return user;
      }
      _scaffoldkey.currentState
          .showSnackBar(SnackBar(content: Text("Successfully Created")));
    } catch (e) {
      if (_formKey.currentState.validate()) {
        _scaffoldkey.currentState.showSnackBar(
            SnackBar(content: Text("Not able to Register" + e.toString())));
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }

  String location;

  Future<Address> convertCotoAdd(Coordinates coordinates) async {
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return addresses.first;
  }

  Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
    if (p != null) {
      // get detail (lat/lng)
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;

      scaffold.showSnackBar(
        SnackBar(content: Text("${p.description} - $lat/$lng")),
      );
    }
  }
}
