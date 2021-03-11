import 'dart:ui';
import 'db.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';

class Delete extends StatefulWidget {
  @override
  _DeleteState createState() => _DeleteState();
}

class _DeleteState extends State<Delete> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String email1;
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    email1 = _auth.currentUser.email;

    return Scaffold(
      appBar: AppBar(
        title: Text("Delete Account"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                fillColor: Colors.grey,
                hintText: email1,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: "Email-Id",
              ),
              style: TextStyle(decorationStyle: TextDecorationStyle.solid),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: pass,
              decoration: InputDecoration(
                labelText: "Password",
              ),
            ),
            Center(
              child: Container(
                child: RaisedButton(
                  child: Text(
                    "Delete",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.red,
                  elevation: 8,
                  onPressed: () async {
                    final id = _auth.currentUser.uid;
                    print(email1);
                    print(id);

                    await Db().deleteauth(id, pass.text);
                    await _auth.currentUser.delete();
                    // print("User deleted succesfully");
                    Db().signOut().whenComplete(
                        () => Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                            (route) => false));
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
