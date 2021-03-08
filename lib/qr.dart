import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'appD.dart';

class CodeQR extends StatefulWidget {
  @override
  _CodeQRState createState() => _CodeQRState();
}

class _CodeQRState extends State<CodeQR> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String uid;
  @override
  Widget build(BuildContext context) {
    uid = _auth.currentUser.uid;
    return Scaffold(
        appBar: new AppBar(
          title: Text('BOP'),
          backgroundColor: Colors.red,
        ),
        drawer: ADrawer(user: _auth.currentUser),
        body: Center(
          child: Container(
            child: QrImage(data: "$uid", version: QrVersions.auto, size: 200),
          ),
        ));
  }
}
