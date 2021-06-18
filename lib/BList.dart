import 'dart:async';
import 'dart:convert';
import 'package:BOD/constants/constants.dart';
import 'package:BOD/screens/app_drawer.dart';
import 'package:BOD/screens/homepage.dart';
import 'package:BOD/screens/terms&conditions.dart';
import 'package:BOD/track_donor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

class View extends StatefulWidget {
  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {
  @override
  void initState() {
    super.initState();
    OneSignal.shared.setNotificationOpenedHandler((result) {
      if (result.action.actionId == "accept_button") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TC()),
        );
      } else if (result.action.actionId == "deny_button") {
        return;
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood').tr(),
        backgroundColor: Colors.red,
      ),
      drawer: ADrawer(),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('user').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return Text("Some Error");
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  final list = snapshot.data.docs;
                  return ListView.builder(
                    itemBuilder: (context, i) {
                      return JobCard(
                        title: list[i]['name'],
                        subtitle: list[i]['email'],
                        bloodGroup: list[i]['Blood-Group'],
                        tokenid: list[i]['tokenId'],
                      );
                    },
                    itemCount: list.length,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class JobCard extends StatefulWidget {
  const JobCard(
      {@required this.title,
      @required this.subtitle,
      @required this.bloodGroup,
      @required this.tokenid});

  final String title;
  final String subtitle;
  final String bloodGroup;
  final String tokenid;

  @override
  _JobCardState createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  @override
  void initState() {
    super.initState();
  }

  Future<Response> sendNotification(
      List<String> tokenIdList, String contents, String heading) async {
    OneSignal.shared.setNotificationOpenedHandler((result) {
      if (result.action.actionId == "accept_button") {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TrackDonor(
                    tokenid: widget.tokenid,
                  )),
        );
        print(widget.tokenid);
      } else if (result.action.actionId == "deny_button") {
        return;
      }
    });
    return await post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": onesignalid,
        'priority': 'high',
        "include_player_ids": tokenIdList,
        "android_accent_color": "FF99000",
        "Lockscreen": "PUBLIC",
        "android_led_color": "FF9976D2",
        "small_icon": "assets/icon/logo.png",
        "android_sound": "notification",
        "large_icon": "assets/icon/logo.png",
        "headings": {"en": heading},
        "contents": {"en": contents},
        "buttons": [
          {
            "id": "accept_button",
            "text": "Accept",
            "icon": "assets/icon/logo.png",
          },
          {"id": "deny_button", "text": "Deny", "icon": "assets/icon/logo.png"}
        ]
      }),
    );
  }

  getuserName() async {
    final id = FirebaseAuth.instance.currentUser.uid;

    await FirebaseFirestore.instance
        .collection('user')
        .doc(id)
        .get()
        .then((value) {
      return value.data()['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 7),
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 8, top: 25, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: const Offset(3.0, 3.0),
              color: Colors.grey.shade500.withOpacity(0.1),
              blurRadius: 6.0,
              spreadRadius: 2.0,
            ),
            BoxShadow(
              offset: const Offset(-3.0, -3.0),
              color: Colors.grey.shade500.withOpacity(0.5),
              blurRadius: 6.0,
              spreadRadius: 3.0,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(fontSize: 10, color: Colors.black),
                ),
                SizedBox(
                  height: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.subtitle,
                      style: TextStyle(color: Colors.black38, fontSize: 6),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      widget.bloodGroup,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 10),
                    ),
                  ],
                )
              ],
            ),
            RaisedButton(
              color: Colors.red,
              onPressed: () {
                sendNotification(
                    [widget.tokenid], "User requested", "FlutterCloudMessage");
              },
              child: Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Request",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
