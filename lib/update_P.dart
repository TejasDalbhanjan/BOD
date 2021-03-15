import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';

class Update extends StatefulWidget {
  Update({Key key}) : super(key: key);

  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  bool checkpassword = true;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController _currentpass = TextEditingController();
  TextEditingController _newpass = TextEditingController();
  TextEditingController _confirmpass = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Changep").tr(), backgroundColor: Colors.red),
      //resizeToAvoidBottomPadding: false,
      body: Form(
        key: _formkey,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: true,
                controller: _currentpass,
                decoration: InputDecoration(
                    errorText: checkpassword ? null : "Check Your Password",
                    hintText: "CurrentPassword".tr(),
                    labelText: "CurrentPassword".tr(),
                    labelStyle: TextStyle(fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: true,
                validator: (value) {
                  if (value.isEmpty || value.length < 8) {
                    return 'Enter Valid password !';
                  }
                  return null;
                },
                controller: _newpass,
                decoration: InputDecoration(
                    hintText: "NewPassword".tr(),
                    labelText: "NewPassword".tr(),
                    labelStyle: TextStyle(fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _confirmpass,
                obscureText: true,
                validator: (String val) {
                  if (val != _newpass.text)
                    return "Invalid Password";
                  else
                    return null;
                },
                decoration: InputDecoration(
                    hintText: "ConfirmPassword".tr(),
                    labelText: "ConfirmPassword".tr(),
                    labelStyle: TextStyle(fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                onPressed: () {
                  setState(() {
                    checkpassword = validatePass(_currentpass.text);
                  });
                },
                color: Colors.redAccent,
                child: Text(
                  "Update",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ).tr(),
              )
            ],
          ),
        ),
      ),
    );
  }

  validatePass(String pass) async {
    var user = _auth.currentUser;

    try {
      var authCredential =
          EmailAuthProvider.credential(email: user.email, password: pass);
      var authResult = await user.reauthenticateWithCredential(authCredential);
      return authResult.user != null;
    } catch (e) {
      print(e);
    }
  }
}
