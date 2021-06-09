import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Blood.dart';
import 'Organ.dart';
import 'appD.dart';
import 'package:easy_localization/easy_localization.dart';

class Dd extends StatefulWidget {
  State createState() => new DropState();
}

class DropState extends State<Dd> {
  String selectedoptions = "-";
  final List<String> select = ["-", "Blood", "Organ"];

  Future getdata() async {
    QueryDocumentSnapshot qn =
        await FirebaseFirestore.instance.collection('user').doc().get();
    return qn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('BOP'),
        backgroundColor: Colors.red,
      ),
      drawer: ADrawer(),
      body: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: "SelectType".tr(),
          border: OutlineInputBorder(
            borderSide: new BorderSide(color: Colors.red),
          ),
        ),
        elevation: 2,
        hint: Container(
          child: Text("Select").tr(),
        ),
        value: selectedoptions,
        items: select.map((String select) {
          return DropdownMenuItem<String>(
            child: Text(select),
            value: select,
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            if (value == "Blood") {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => BloodD()));
            } else if (value == "Organ") {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => OrganD()));
            }
          });
        },
      ),
    );
  }
}
