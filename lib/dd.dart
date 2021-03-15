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
        ),
        elevation: 4,
        hint: Container(
          child: Text("Select").tr(),
        ),
        items: select.map((String select) {
          return DropdownMenuItem<String>(
            child: Text(select),
            value: select,
          );
        }).toList(),
        value: selectedoptions,
        onChanged: (value) {
          setState(() {
            if (value == "Blood") {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => BloodD()));
            } else if (value == "Organ") {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => OrganD()));
            }
          });
        },
      ),
    );
  }
}
