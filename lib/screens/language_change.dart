import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ChangeL extends StatefulWidget {
  @override
  _ChangeLState createState() => _ChangeLState();
}

class _ChangeLState extends State<ChangeL> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.redAccent,
        title: Text(
          'CL',
          style: TextStyle(color: Colors.white),
        ).tr(),
      ),
      body: Column(
        children: <Widget>[
          Card(
            child: ListTile(
              title: Text("English"),
              onTap: () {
                context.locale = Locale('en', 'US');
                Navigator.of(context).pop();
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Marathi"),
              onTap: () {
                context.locale = Locale('mr', 'IN');
                Navigator.of(context).pop();
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Hindi"),
              onTap: () {
                context.locale = Locale('hi', 'IN');
                Navigator.of(context).pop();
              },
            ),
          )
        ],
      ),
    );
  }
}
