import 'package:BOD/db.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'changeL.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'update_P.dart';
import 'editProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'delete.dart';

class Set extends StatefulWidget {
  @override
  _SetState createState() => _SetState();
}

class _SetState extends State<Set> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final userCollection = FirebaseFirestore.instance.collection('user');
  QuerySnapshot name;

  @override
  void initState() {
    super.initState();
    Db().getUserdata().then(
      (value) {
        setState(
          () {
            name = value;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.redAccent,
        title: Text(
          'Setting',
          style: TextStyle(color: Colors.white),
        ).tr(),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Center(
                    child: Row(
                      children: [
                        getProfileImage(),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [getuserInfo(), getProfileemail()],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.001,
                  color: Colors.black,
                ),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Card(
                        elevation: 5,
                        child: ListTile(
                          leading:
                              Icon(Icons.edit_off, color: Colors.redAccent),
                          title: Text('Ep').tr(),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Editp()));
                          },
                        ),
                      ),
                      Card(
                        elevation: 5,
                        child: ListTile(
                            leading: Icon(Icons.lock_outline,
                                color: Colors.redAccent),
                            title: Text('Changep').tr(),
                            trailing: Icon(Icons.keyboard_arrow_right),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Update()));
                            }),
                      ),
                      Card(
                        elevation: 5,
                        child: ListTile(
                          leading:
                              Icon(Icons.language, color: Colors.redAccent),
                          title: Text('ChangeL').tr(),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChangeL()));
                          },
                        ),
                      ),
                      Card(
                        elevation: 5,
                        child: ListTile(
                          leading: Icon(Icons.delete, color: Colors.redAccent),
                          title: Text('DA').tr(),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Delete()));
                          },
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: (20.0),
                ),
                Center(
                  child: Container(
                    child: CircularPercentIndicator(
                      progressColor: Colors.redAccent,
                      radius: 5,
                      percent: 0.8,
                    ),
                  ),
                ),
              ],
            ),
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

  Stream<QuerySnapshot> get users {
    return userCollection.snapshots();
  }

  getuserInfo() {
    final id = _auth.currentUser.uid;
    return StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('user').doc(id).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text("Loading ...Please wait");
          return Text(
            snapshot.data['name'],
            style: TextStyle(fontWeight: FontWeight.bold),
          );
        });
  }

  getcount() {
    final id = _auth.currentUser.uid;
    return StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('user').doc(id).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text("Loading ...Please wait");
          return snapshot.data['Count'];
        });
  }
}
