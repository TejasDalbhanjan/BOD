import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'db.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';

import 'homepage.dart';

class BBFul extends StatefulWidget {
  @override
  State createState() => BBState();
}

const kGoogleApiKey = "AIzaSyDbtEjg1C6-43fkzRdPq406uYSJGaBMExI";

class BBState extends State<BBFul> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _name = TextEditingController();
  TextEditingController _phoneno = TextEditingController();
  TextEditingController _lic = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  StreamSubscription<Position> _streamSubscription;
  File file;
  String _fileName;
  String _path;
  String _errorpass;
  Position _position;
  Address _address;
  TextEditingController _controller = TextEditingController();
  LatLng coordinates;
  String lat;
  String long;
  String _add;
  String locationMessage = "";
  String _extension;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _addController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _confirmpassController = TextEditingController();

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

  _openFileExplorer() async {
    try {
      file = await FilePicker.getFile(type: FileType.image);
      print(file.path);
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;

    setState(() {
      _fileName = file.path != null ? _path.split('/').last : "...";
    });
  }

  Future upload() async {
    String name = file.path.split('/').last;
    Reference reference = FirebaseStorage.instance.ref().child(name);
    UploadTask uploadTask = reference.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    setState(() {
      print("Uploaded Succesfully");
    });
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    return Scaffold(
      key: _scaffoldkey,
      appBar:
          AppBar(title: Text("DetailsHH").tr(), backgroundColor: Colors.red),
      //resizeToAvoidBottomPadding: false,
      body: Form(
        key: _formKey,
        child: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new Image(
              image: AssetImage("assets/logo.jpg"),
              fit: BoxFit.fill,
              color: Colors.black12,
              colorBlendMode: BlendMode.colorBurn,
            ),
            SingleChildScrollView(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 40),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                              child: TextFormField(
                                controller: _name,
                                validator: (val) {
                                  if (val.isEmpty)
                                    return ("Enter Name");
                                  else
                                    return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'nameoHH'.tr(),
                                  labelStyle: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                keyboardType: TextInputType.name,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                              child: TextFormField(
                                controller: _addController,
                                validator: (val) {
                                  if (val.isEmpty)
                                    return ("Inavlid Address");
                                  else
                                    return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'adHH'.tr(),
                                  labelStyle: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                keyboardType: TextInputType.multiline,
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
                                  labelStyle: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                              child: Row(
                                children: [
                                  Text(
                                    'Certificate'.tr(),
                                    semanticsLabel: "Upload Image",
                                    style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black,
                                      fontSize: 16,
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
                                                _openFileExplorer();
                                              }),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                              child: TextFormField(
                                controller: _lic,
                                validator: (val) {
                                  if (val.isEmpty || val.length < 10)
                                    return ("Inavlid License Number");
                                  else
                                    return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'LN'.tr(),
                                  labelStyle: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
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
                                  labelStyle: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black,
                                    fontSize: 16,
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
                                  labelStyle: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                obscureText: true,
                              ),
                            ),
                            Container(
                              height: 50,
                              child: MaterialButton(
                                onPressed: () {
                                  _registerAccount();
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
                                    'SUBMIT'.tr(),
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
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  GlobalKey<FormState> buildFormKey() => _formKey;

  Future _registerAccount() async {
    String name = _name.text;
    String add = _addController.text;
    String lic = _lic.text;

    if (_addController.text.isNotEmpty || _addController.text.length >= 8) {
      add = _addController.text;
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

        await Db().createHospitalBBdata(
          name,
          add,
          lic,
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
