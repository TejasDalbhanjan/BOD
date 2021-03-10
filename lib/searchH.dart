import 'package:qrscans/qrscan.dart' as scanner;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'appD.dart';
//import 'package:qrscan/qrscan.dart' as scanner;

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
            onPressed: () async {
              _scan();
            },
          ),
          Padding(padding: EdgeInsets.all(5))
        ],
      ),
      drawer: ADrawer(user: _auth.currentUser),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Center(
            child: Text(
              "Donate Blood",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
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

  Future _scan() async {
    String barcode = await scanner.scan();
    print(barcode);
  }
}
