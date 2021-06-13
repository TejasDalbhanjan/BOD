import 'dart:io';
import 'package:BOD/screens/forms/camp_registration_form.dart';
import '../services/database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../dd.dart';
import 'terms&conditions.dart';
import 'app_drawer.dart';
import 'settings.dart';
import 'package:easy_localization/easy_localization.dart';
import '../model/map.dart';

class BottomNB extends StatefulWidget {
  final User user;
  const BottomNB({Key key, this.user}) : super(key: key);

  @override
  _BottomNBState createState() => _BottomNBState();
}

final _auth = FirebaseAuth.instance;
final id = _auth.currentUser.uid;

class _BottomNBState extends State<BottomNB> {
  bool state = false;

  List<Widget> _list = [
    Mapp(),
    Dd(),
    DateTimePickerWidget(),
    TC(),
    Set(),
  ];
  final GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();

  int _index = 0;

  Future<bool> hospital() {
    if (Db().gethospital(id) == true) {
      state = true;
      return Future.value(true);
    } else {
      state = false;
      return Future.value(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        key: _globalKey,
        drawer: ADrawer(),
        resizeToAvoidBottomPadding: false,
        body: _list[_index],
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              _index = index;
            });
          },
          currentIndex: _index,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: ('Home').tr(),
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.request_page),
              label: ('Request').tr(),
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_business_rounded),
              label: ('Camp'),
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: ('Search').tr(),
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: ('Profile').tr(),
              backgroundColor: Colors.white,
            ),
          ],
          selectedItemColor: Colors.redAccent,
          unselectedItemColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          iconSize: 30,
        ),
      ),
      onWillPop: () async {
        if (_globalKey.currentState.isDrawerOpen) {
          Navigator.of(context).pop();
          return Future.value(false);
        } else {
          if (_index == 0) {
            _onBackPressed();
          }
          //return true;
          setState(() {
            _index = 0;
          });
          return false;
        }
      },
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Text("NO"),
          ),
          SizedBox(height: 16),
          new GestureDetector(
            onTap: () {
              exit(0);
            },
            child: Text("YES"),
          ),
        ],
      ),
    );
  }
}
