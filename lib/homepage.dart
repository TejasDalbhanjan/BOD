import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dd.dart';
import 'TC.dart';
import 'appD.dart';
import 'settings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'map.dart';

class BottomNB extends StatefulWidget {
  final User user;
  const BottomNB({Key key, this.user}) : super(key: key);

  @override
  _BottomNBState createState() => _BottomNBState();
}

class _BottomNBState extends State<BottomNB> {
  List<Widget> _list = [
    Mapp(),
    Dd(),
    TC(),
    Set(),
  ];
  final GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();

  int _index = 0;
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
          Navigator.of(context).pop(); // closes the drawer if opened
          return Future.value(false);
        } else {
          if (_index == 0) _onBackPressed();
          //return true;
          setState(() {
            _index = 0;
          });

          return Future.value(true);
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
