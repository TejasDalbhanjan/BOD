import 'dart:async';
import 'package:flutter/material.dart';
import 'screens/registration_selection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/homepage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  State createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool _secureText = true;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      key: _scaffoldkey,
      resizeToAvoidBottomPadding: false,
      body: Form(
        key: formkey,
        child: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new Image(
              image: AssetImage(
                "assets/logo.jpg",
              ),
              fit: BoxFit.fill,
              color: Colors.black.withOpacity(0.1),
              colorBlendMode: BlendMode.dstATop,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 1,
              width: MediaQuery.of(context).size.width * 1,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Center(
                    child: Text(
                      "BOD",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: MediaQuery.of(context).size.height * 0.1,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: TextFormField(
                      controller: _emailController,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () => node.nextFocus(),
                      validator: (value) {
                        if (value.isEmpty ||
                            !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                          return 'Enter a valid email!';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: 'Email_id'.tr(),
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.03,
                              color: Colors.black)),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: TextFormField(
                      controller: _passController,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => node.unfocus(),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter a valid password!';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Password'.tr(),
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.height * 0.03,
                            color: Colors.black),
                        suffixIcon: IconButton(
                          icon: Icon(_secureText
                              ? Icons.remove_red_eye
                              : Icons.security),
                          onPressed: () {
                            setState(() {
                              _secureText = !_secureText;
                            });
                          },
                        ),
                      ),
                      obscureText: _secureText,
                      keyboardAppearance: Brightness.light,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.045),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.064,
                    child: MaterialButton(
                      onPressed: () async {
                        if (formkey.currentState.validate()) {
                          final SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          pref.setStringList('credentials',
                              [_emailController.text, _passController.text]);
                          signInWithEmailAndPassword();
                        } else {
                          _scaffoldkey.currentState.showSnackBar(
                              SnackBar(content: Text("Failed To SignIn")));
                        }
                      },
                      color: Colors.red,
                      highlightColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.white),
                      ),
                      elevation: 8.0,
                      child: Center(
                        child: Text(
                          'Log_IN',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height * 0.03,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ).tr(),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.045),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Asa()),
                            );
                          },
                          child: Text(
                            'New_reg',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.02,
                              decoration: TextDecoration.underline,
                              textBaseline: TextBaseline.alphabetic,
                            ),
                          ).tr(),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.43),
                        InkWell(
                          onTap: () {
                            if (true) {
                              sendPasswordResetEmail(_emailController.text);
                            }
                          },
                          child: Text(
                            'Forgot_p',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.02,
                              decoration: TextDecoration.underline,
                              textBaseline: TextBaseline.alphabetic,
                            ),
                          ).tr(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Container(
                    child: Center(
                      child: InkWell(
                        child: Text(
                          "Blood and Organ Donation Management",
                          style: TextStyle(color: Colors.grey),
                        ),
                        focusColor: Colors.grey,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future sendPasswordResetEmail(String email) async {
    return _auth.sendPasswordResetEmail(email: email);
  }

  void signInWithEmailAndPassword() async {
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
              email: _emailController.text, password: _passController.text))
          .user;
      if (!user.emailVerified) {
        await user.sendEmailVerification();
      }

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => BottomNB(
                user: user,
              )));
    } catch (e) {
      if (formkey.currentState.validate()) {
        _scaffoldkey.currentState.showSnackBar(
            SnackBar(content: Text("Failed To SignIn" + e.toString())));
      }

      print(e);
    }
  }
}
