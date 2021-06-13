import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';
import '../services/database.dart';

class Editp extends StatefulWidget {
  @override
  _EditpState createState() => _EditpState();
}

class _EditpState extends State<Editp> {
  bool editemail = true;
  bool editphone = true;

  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  String email;
  String emailnew;
  @override
  Widget build(BuildContext context) {
    final id = _auth.currentUser.uid;
    email = _auth.currentUser.email;
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text("Ep").tr(),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            TextField(
              onChanged: (val) {
                emailnew = val;
              },
              readOnly: editemail,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(Icons.edit),
                  color: editemail ? Colors.black : Colors.blue,
                  onPressed: () {
                    setState(() {
                      editemail = !editemail;
                    });
                  },
                ),
                labelText: "Email_id".tr(),
                hintText: email,
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              readOnly: editphone,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                labelText: "PhoneN".tr(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                suffixIcon: IconButton(
                  icon: Icon(Icons.edit),
                  color: editphone ? Colors.black : Colors.blue,
                  onPressed: () {
                    setState(() {
                      editphone = !editphone;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              onPressed: () {
                Db().updateDataUser(emailnew, id);

                Db().updateAuth(emailnew).whenComplete(
                    () => _scaffoldkey.currentState.showSnackBar(SnackBar(
                          content: Text("Successfully Updated"),
                        )));
              },
              child: Text("Update").tr(),
            )
          ],
        ),
      ),
    );
  }
}
