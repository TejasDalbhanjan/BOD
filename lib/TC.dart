import 'package:flutter/material.dart';
import 'searchH.dart';
import 'homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TC extends StatefulWidget {
  final User user;
  const TC({Key key, this.user}) : super(key: key);
  @override
  _AccDecState createState() => _AccDecState();
}

class _AccDecState extends State<TC> {
  bool _val = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("BOD"), backgroundColor: Colors.red),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Terms & Conditions ",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                reverse: true,
                child: Column(
                  children: <Widget>[
                    Text(
                      'This Terms of Service Agreement (the "Agreement") is between you ("you") and BOD (together with our service providers, and partners, "we," and/or "us") and governs your use of the application, including the materials and information posted on it, and the functionality that permits you to make donations, solicit donations, create an account, apply for a grant, solicit donations for a project, or to use any other functionality offered through the app.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '1.Acceptance of Terms and Supplementary Terms. BOD operates the app subject to this Agreement, including the Privacy Policy and any additional guidelines, rules, terms and conditions, or limitations applicable to specific components of the app(each, a "Supplementary Term"), each of which is incorporated by reference herein.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '2.Modification, Suspension, and/or Cancellation. GlobalGiving reserves the right to update the app,and change, suspend, or discontinue providing all or part of the content or functionality of the app in its sole discretion, with or without notice.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '3.Personal Information. BODs use of personal information collected from and about you in connection with your use of the app(e.g., as part of your Profile) is governed by our Privacy Policy, (the "Privacy Policy"), and which is incorporated by reference into this Agreement as a Supplementary Term. By providing this personal information, subject to the terms of the Privacy Policy, you grant to BOD a perpetual, irrevocable, transferable, worldwide, royalty-free license to use, reproduce and store, and subject to your privacy preferences, to display, publish, transmit and distribute such information in connection with the operation of the app.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '4.User Policy. When you create an account or profile, you will be asked to provide certain personal information, such as your name and contact information, and given the opportunity to select one or more user names and passwords (collectively, your "User ID").',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
              child: Row(
            children: <Widget>[
              Checkbox(
                  value: _val,
                  onChanged: (value) {
                    setState(() {
                      _val = value;
                    });
                  }),
              Container(
                  child: Text('I have read and accept Terms & Conditions')),
            ],
          )),
          Container(
            height: 50,
            child: MaterialButton(
              onPressed: _val
                  ? () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SearchH()));
                    }
                  : null,
              color: Colors.red,
              highlightColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.white),
              ),
              elevation: 8.0,
              child: Center(
                child: Text(
                  'ACCEPT',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 50),
          Container(
            height: 50,
            child: MaterialButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BottomNB()));
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
                  'DECLINE',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
