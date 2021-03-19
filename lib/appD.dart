import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'settings.dart';
import 'package:qrscans/qrscan.dart' as scanner;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'db.dart';
import 'qr.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ADrawer extends StatefulWidget {
  final User user;
  const ADrawer({Key key, this.user}) : super(key: key);
  State createState() => new ADrawerState();
}

class ADrawerState extends State<ADrawer> {
  QrImage qr;

  FirebaseAuth _auth = FirebaseAuth.instance;
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.red[300],
            ),
            accountName: null,
            accountEmail: getProfileemail(),
            currentAccountPicture: getProfileImage(),
            otherAccountsPictures: [
              IconButton(
                icon: Icon(Icons.qr_code_scanner_sharp),
                onPressed: () async {
                  _scan();
                },
                color: Colors.white,
                iconSize: 40,
              )
            ],
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home').tr(),
            hoverColor: Colors.red,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          _divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Setting').tr(),
            hoverColor: Colors.red,
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Set()));
            },
          ),
          _divider(),
          ListTile(
            leading: Icon(Icons.supervisor_account),
            title: Text('Aboutu').tr(),
            hoverColor: Colors.red,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          _divider(),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Help'),
            hoverColor: Colors.red,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          _divider(),
          ListTile(
              leading: Icon(Icons.qr_code),
              title: Text('QrCode').tr(),
              hoverColor: Colors.red,
              onTap: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => CodeQR()));
              }),
          _divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout').tr(),
            hoverColor: Colors.red,
            onTap: () async {
              final SharedPreferences pref =
                  await SharedPreferences.getInstance();
              await pref.clear();
              await Db()
                  .signOut()
                  .whenComplete(() => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                      (route) => false));
            },
          ),
        ],
      ),
    );
  }

  getProfileImage() {
    if (_auth.currentUser.photoURL != null) {
      return Image.network(_auth.currentUser.photoURL, height: 100, width: 100);
    } else {
      return Icon(Icons.account_circle, size: 100);
    }
  }

  getProfileemail() {
    if (_auth.currentUser.email != null) {
      return Text(_auth.currentUser.email);
    } else {
      return Text("User@user.com");
    }
  }

  _divider() {
    return Container(
      color: Colors.black,
      height: MediaQuery.of(context).size.height * 0.001,
    );
  }

  Future _scan() async {
    String barcode = await scanner.scan();
    print(barcode);
  }
}
