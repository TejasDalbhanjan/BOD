import 'dart:io';
import 'package:BOD/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:geolocator/geolocator.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../../services/database.dart';
import 'dart:async';
import '../homepage.dart';
import 'package:flutter/cupertino.dart';

class Donorf extends StatefulWidget {
  @override
  State createState() => DonorfState();
}

class DonorfState extends State<Donorf> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _displayName = TextEditingController();
  TextEditingController _phoneno = TextEditingController();
  TextEditingController _bloodg = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController _confirmpassController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _adharController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  String _errorpass;
  Position _position;
  Address _address;
  StreamSubscription<Position> _streamSubscription;
  File file;
  String _fileName;
  String _path;
  Map<String, String> _paths;
  TextEditingController _controller = TextEditingController();
  String _add;
  String locationMessage = "";
  GeoPoint coordinates;

  void getCurrentLocation() async {
    final position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      locationMessage = "${position.latitude}, ${position.longitude}";
      coordinates = GeoPoint(position.latitude, position.longitude);
      locationController.text = placemark[0].name +
          ", " +
          placemark[0].thoroughfare +
          ", " +
          placemark[0].subLocality +
          ", " +
          placemark[0].locality +
          " - " +
          placemark[0].postalCode +
          ", " +
          placemark[0].administrativeArea;
      print(locationController.text);
      print(coordinates);
    });
  }

  @override
  void initState() {
    super.initState();
    String _extension;

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

  void _showModal(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Column(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                        onPressed: () {
                          setState(() {
                            _bloodg.text = "O+";
                            Navigator.of(context).pop();
                          });
                        },
                        child: Text(
                          "O+",
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold),
                        ),
                        color: Colors.blue,
                        elevation: 8,
                        hoverColor: Colors.white,
                        highlightColor: Colors.red,
                      ),
                      RaisedButton(
                        onPressed: () {
                          setState(() {
                            _bloodg.text = "O-";
                            Navigator.of(context).pop();
                          });
                        },
                        child: Text(
                          "O-",
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold),
                        ),
                        color: Colors.blue,
                        elevation: 8,
                        hoverColor: Colors.white,
                        highlightColor: Colors.red,
                      ),
                      RaisedButton(
                        onPressed: () {
                          setState(() {
                            _bloodg.text = "A+";
                            Navigator.of(context).pop();
                          });
                        },
                        child: Text(
                          "A+",
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold),
                        ),
                        color: Colors.blue,
                        elevation: 8,
                        hoverColor: Colors.white,
                        highlightColor: Colors.red,
                      ),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                        onPressed: () {
                          setState(() {
                            _bloodg.text = "A-";
                            Navigator.of(context).pop();
                          });
                        },
                        child: Text(
                          "A-",
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold),
                        ),
                        color: Colors.blue,
                        elevation: 8,
                        hoverColor: Colors.white,
                        highlightColor: Colors.red,
                      ),
                      RaisedButton(
                        onPressed: () {
                          setState(() {
                            _bloodg.text = "B+";
                            Navigator.of(context).pop();
                          });
                        },
                        child: Text(
                          "B+",
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold),
                        ),
                        color: Colors.blue,
                        elevation: 8,
                        hoverColor: Colors.white,
                        highlightColor: Colors.red,
                      ),
                      RaisedButton(
                        onPressed: () {
                          setState(() {
                            _bloodg.text = "AB+";
                            Navigator.of(context).pop();
                          });
                        },
                        child: Text(
                          "AB+",
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold),
                        ),
                        color: Colors.blue,
                        elevation: 8,
                        hoverColor: Colors.white,
                        highlightColor: Colors.red,
                      ),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                        onPressed: () {
                          setState(() {
                            _bloodg.text = "AB-";
                            Navigator.of(context).pop();
                          });
                        },
                        child: Text(
                          "AB-",
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold),
                        ),
                        color: Colors.blue,
                        elevation: 8,
                        hoverColor: Colors.white,
                        highlightColor: Colors.red,
                      ),
                      RaisedButton(
                        onPressed: () {
                          setState(() {
                            _bloodg.text = "B-";
                            Navigator.of(context).pop();
                          });
                        },
                        child: Text(
                          "B-",
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold),
                        ),
                        color: Colors.blue,
                        elevation: 8,
                        hoverColor: Colors.white,
                        highlightColor: Colors.red,
                      ),
                    ])
              ]));
        });
  }

  Future upload() async {
    String name = file.path.split('/').last;
    Reference reference = FirebaseStorage.instance.ref().child(name);
    UploadTask uploadTask = reference.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    return Scaffold(
      key: _scaffoldkey,
      appBar:
          AppBar(title: Text("DetailsOD").tr(), backgroundColor: Colors.red),
      resizeToAvoidBottomPadding: false,
      body: Form(
        key: _formKey,
        child: Container(
          child: new Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width * 1,
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  reverse: true,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                        child: TextFormField(
                          controller: _displayName,
                          decoration: InputDecoration(
                            labelText: 'name'.tr(),
                            labelStyle: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
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
                        child: TextFormField(
                          readOnly: true,
                          controller: locationController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter address!';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(Icons.location_on),
                              onPressed: () {
                                getCurrentLocation();
                              },
                            ),
                            alignLabelWithHint: true,
                            labelText: 'Ad'.tr(),
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
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter age!';
                            }
                            return null;
                          },
                          controller: _ageController,
                          decoration: InputDecoration(
                            labelText: 'Age'.tr(),
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
                          validator: (value) {
                            if (value.isEmpty || value.length != 10) {
                              return 'Enter Phone Number!';
                            }
                            return null;
                          },
                          controller: _phoneno,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
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
                          readOnly: true,
                          onTap: () => _showModal(context),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter Blood Group!';
                            }
                            return null;
                          },
                          controller: _bloodg,
                          decoration: InputDecoration(
                            labelText: 'Blood Group',
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
                        child: Row(
                          children: [
                            Text(
                              'Health-History',
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
                                      icon: Icon(Icons.add_a_photo_outlined),
                                      onPressed: () async {
                                        _openFileExplorer();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            RaisedButton(
                              onPressed: () {
                                upload().whenComplete(() {
                                  _scaffoldkey.currentState
                                      .showSnackBar(SnackBar(
                                    content: Text("Upload Succesfully"),
                                  ));
                                });
                              },
                              child: Text("Upload"),
                            ),
                          ],
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
                      new Builder(
                        builder: (BuildContext context) => new Container(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          height: MediaQuery.of(context).size.height * 0.08,
                          child: new Scrollbar(
                            child: _path != null || _paths != null
                                ? new ListView.separated(
                                    itemCount:
                                        _paths != null && _paths.isNotEmpty
                                            ? _paths.length
                                            : 1,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final String name = _fileName;

                                      return new ListTile(
                                        title: new Text(
                                          name,
                                        ),
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            new Divider(),
                                  )
                                : new Container(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              MaterialButton(
                height: MediaQuery.of(context).size.height * 0.07,
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
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
            ],
          ),
        ),
      ),
    );
  }

  GlobalKey<FormState> buildFormKey() => _formKey;

  Future _registerAccount() async {
    String name = _displayName.text;
    String email1 = _emailController.text;
    String adhar = _adharController.text;
    String age = _ageController.text;
    String add;
    String phone = _phoneno.text;
    String bloodg = _bloodg.text;

    if (locationController.text.isNotEmpty ||
        locationController.text.length >= 8) {
      add = locationController.text;
    } else {
      add = _add;
    }
    print("On Register account");
    try {
      UserCredential result = (await _auth.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passController.text));
      User user = result.user;
      var status = await OneSignal.shared.getPermissionSubscriptionState();
      String tokenId = status.subscriptionStatus.userId;
      if (user != null) {
        if (!user.emailVerified) {
          await user.sendEmailVerification();
        }

        await Db().createUserData(
          name,
          email1,
          add,
          age,
          phone,
          bloodg,
          adhar,
          coordinates,
          tokenId,
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
}
