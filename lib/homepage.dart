import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dd.dart';
import 'TC.dart';
import 'settings.dart';
import 'miniHP.dart';

class BottomNB extends StatefulWidget {
  final User user;
  const BottomNB({Key key, this.user}) : super(key: key);

  @override
  _BottomNBState createState() => _BottomNBState();
}

class _BottomNBState extends State<BottomNB> {
  List<Widget> _list = [
    Homep(),
    Dd(),
    TC(),
    Set(),
  ];
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            label: ('Home'),
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.request_page),
            label: ('Request'),
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: ('Search'),
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: ('Profile'),
            backgroundColor: Colors.white,
          ),
        ],
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        iconSize: 30,
      ),
    );
  }
}
