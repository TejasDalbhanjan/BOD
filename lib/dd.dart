import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Blood.dart';
import 'Organ.dart';
import 'screens/app_drawer.dart';

class Dd extends StatefulWidget {
  State createState() => new DropState();
}

class DropState extends State<Dd> {
  Future getdata() async {
    QueryDocumentSnapshot qn =
        await FirebaseFirestore.instance.collection('user').doc().get();
    return qn;
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('BOP'),
      backgroundColor: Colors.red,
    );
    return Scaffold(
        appBar: appBar,
        drawer: ADrawer(),
        body: Column(
          children: [
            Container(
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom) *
                  0.45,
              width: MediaQuery.of(context).size.width * 1,
              child: MaterialButton(
                onPressed: () {
                  setState(() {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => BloodD()));
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(40),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: Image(
                              image: AssetImage(
                            "assets/icon/drop.png",
                          )),
                        ),
                        Text(
                          "Request Bloood",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: MediaQuery.of(context).size.height * 0.04,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(color: Colors.black),
                ),
                color: Colors.grey[100],
                hoverColor: Colors.grey,
                elevation: 8,
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.003,
            ),
            Container(
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom) *
                  0.45,
              width: MediaQuery.of(context).size.width * 1,
              child: MaterialButton(
                elevation: 8,
                onPressed: () {
                  setState(() {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => OrganD()));
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(40),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: Image(
                              image: AssetImage(
                            "assets/icon/heart-muscle.png",
                          )),
                        ),
                        Text(
                          "Request Organ",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: MediaQuery.of(context).size.height * 0.04,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(color: Colors.black),
                ),
                color: Colors.grey[100],
                hoverColor: Colors.grey,
              ),
            ),
          ],
        ));
  }
}
