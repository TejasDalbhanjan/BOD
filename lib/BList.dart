import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'TC.dart';

class View extends StatefulWidget {
  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      try {
        Navigator.push(
          context,
          MaterialPageRoute(
            settings: RouteSettings(name: '/a'),
            builder: (context) => TC(),
          ),
        );
      } catch (e) {
        print('e : ' + e.toString());
      }
    });
  }

  final TextEditingController _textController = TextEditingController();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('user').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return Text("Some Error");
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading...");
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
    );
  }

  final String serverToken =
      "AAAAH48hMfk:APA91bGtzLwnw8WNNy_6ClIC30qlGv7Ky_wgafp1BvSWBEjeCzDhDXDLfMSAQcUah2lNP5DaDUXpC3vI8Dg_X74goCuxk-KjMZdyM8gK4CSMeqdPrR8OY0j2Fyi-nXyo42NzUmkaGzM4";

  Future<Map<String, dynamic>> sendAndRetrieveMessage(String token) async {
    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': _textController.text,
            'title': 'FlutterCloudMessage'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': token,
        },
      ),
    );
    getuserName() {
      final id = FirebaseAuth.instance.currentUser.uid;
      return StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('user').doc(id).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Text("Loading ...Please wait");

            return snapshot.data['name'];
          });
    }

    _textController.text = getuserName().toString() + 'Requested Blood';
    final Completer<Map<String, dynamic>> completer =
        Completer<Map<String, dynamic>>();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
    );

    return completer.future;
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
  Future<Response> sendNotification(
      List<String> tokenIdList, String contents, String heading) async {
    return await post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "app_id":
            "61bd310f-cf42-48f6-9f66-7dbab9bed2f5", //kAppId is the App Id that one get from the OneSignal When the application is registered.
        'priority': 'high',
        "include_player_ids":
            tokenIdList, //tokenIdList Is the List of All the Token Id to to Whom notification must be sent.

        // android_accent_color reprsent the color of the heading text in the notifiction
        "android_accent_color": "FF0000FF",
        "android_led_color": "FF0000FF",
        "small_icon": "ic_stat_onesignal_default",
        "android_sound": "notification",

        "large_icon":
            "https://www.filepicker.io/api/file/zPloHSmnQsix82nlj9Aj?filename=name.jpg",

        "headings": {"en": heading},

        "contents": {"en": contents},
        "buttons": [
          {
            "id": "id2",
            "text": "Accept",
            "icon": "ic_menu_share",
            "actionId": ""
          },
          {"id": "id1", "text": "Deny", "icon": "ic_menu_send", "actionId": ""}
        ]
      }),
    );
  }

  getuserName() {
    final id = FirebaseAuth.instance.currentUser.uid;
    return StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('user').doc(id).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text("Loading ...Please wait");

          return snapshot.data['name'];
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
            GestureDetector(
              onTap: () => sendNotification(
                  [widget.tokenid], "hello", "FlutterCloudMessage"),
              child: Container(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.accessibility),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/*
*/
