import 'package:flutter/material.dart';
//import 'Asa.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../login.dart';
import 'homepage.dart';

List<String> finalcredential;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BOD',
      debugShowCheckedModeBanner: false,
      home: SplashS(),
    );
  }
}

class SplashS extends StatefulWidget {
  @override
  _SplashSState createState() => _SplashSState();
}

class _SplashSState extends State<SplashS> {
  @override
  void initState() {
    getValidationData().whenComplete(() async {
      Timer(
          Duration(seconds: 2),
          () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>
                      (finalcredential == null ? LoginPage() : BottomNB()),
                ),
              ));
    });
    super.initState();
  }

  Future getValidationData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      var obtainedcredential = pref.getStringList('credentials');
      finalcredential = obtainedcredential;
      print(obtainedcredential);
    });
    print(finalcredential);
  }

  Widget build(BuildContext context) {
    return new Scaffold(
        body: Stack(fit: StackFit.expand, children: <Widget>[
      Column(children: <Widget>[
        Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Image(
                    image: AssetImage(
                      "assets/icon/logo.png",
                    ),
                    fit: BoxFit.cover,
                  ),
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.height * 0.3,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
              ],
            ))
      ]),
    ]));
  }
}
