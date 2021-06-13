import 'package:flutter/material.dart';
import 'forms/donor_form.dart';
import 'forms/BB&Hospital_form.dart';
import 'package:easy_localization/easy_localization.dart';

class Asa extends StatefulWidget {
  State createState() => new _LoginasState();
}

class _LoginasState extends State<Asa> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Register').tr(),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.height * 0.4,
              padding: EdgeInsets.all(10),
              child: RaisedButton(
                onPressed: () {
                  _push(context, Donorf());
                },
                child: Text(
                  "AsaD".tr(),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                color: Colors.red,
                highlightColor: Colors.black,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.height * 0.4,
              padding: EdgeInsets.all(10),
              child: RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BBFul()),
                  );
                },
                child: Text(
                  "AsaH".tr(),
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                color: Colors.red,
                highlightColor: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _push(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return page;
    }));
  }
}
