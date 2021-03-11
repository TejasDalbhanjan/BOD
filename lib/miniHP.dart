import 'package:flutter/material.dart';

class Homep extends StatefulWidget {
  @override
  _HomepState createState() => _HomepState();
}

class _HomepState extends State<Homep> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home"), backgroundColor: Colors.red),
      body: Container(
        child: Center(
          child: RaisedButton(
            onPressed: () {
              return showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Alert!'),
                  content: Text("You are already in Home Page"),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text("okay"),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
