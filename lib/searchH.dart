import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'appD.dart';
import 'package:qr_utils/qr_utils.dart';

class SearchH extends StatefulWidget {
  final User user;
  const SearchH({Key key, this.user}) : super(key: key);

  State createState() => new SearchHState();
}

class SearchHState extends State<SearchH> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('BOP'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code_scanner),
            onPressed: () {
              final qrResult = QrUtils.scanQR;
              print(qrResult);
            },
          ),
          Padding(padding: EdgeInsets.all(5))
        ],
      ),
      drawer: ADrawer(user: _auth.currentUser),
      body: Column(
        children: <Widget>[
          Center(
            child: Text(
              "Donate Blood",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            child: TextField(
              decoration: InputDecoration(
                labelText: "Search for BB/Hospital",
                border: OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.red),
                ),
                prefixIcon: Icon(Icons.location_pin),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
