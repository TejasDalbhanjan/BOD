import 'package:flutter/material.dart';
import 'appD.dart';
import 'package:easy_localization/easy_localization.dart';
import 'Organ.dart';

class BloodD extends StatefulWidget {
  @override
  _BloodDState createState() => _BloodDState();
}

class _BloodDState extends State<BloodD> {
  String selectedoptions = "-";
  String selectedoptions2 = "-";

  final List<String> select = ["-", "Blood", "Organ"];

  final List<String> blood = ["-", "O+", "O-", "AB+"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Blood').tr(),
        backgroundColor: Colors.red,
      ),
      drawer: ADrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 5,
          ),
          DropdownButtonFormField<String>(
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BloodD()));
                } else if (value == "Organ") {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => OrganD()));
                }
              });
            },
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Sb",
            textAlign: TextAlign.left,
          ).tr(),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: "Blood".tr()),
            elevation: 4,
            hint: Container(
              child: Text("Blood").tr(),
            ),
            items: blood.map((String blood) {
              return DropdownMenuItem<String>(
                child: Text(blood),
                value: blood,
              );
            }).toList(),
            value: selectedoptions,
            onChanged: (value) {
              setState(() {
                selectedoptions2 = value;
              });
            },
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Text(
                "SearchLoc",
                textAlign: TextAlign.left,
              ).tr(),
              SizedBox(
                width: 190,
              ),
              InkWell(
                radius: 10,
                onTap: () {},
                child: Text(
                  "CurrentLoc",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.red,
                  ),
                ).tr(),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: TextField(
              decoration: InputDecoration(
                labelText: "Search".tr(),
                border: OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.red),
                ),
                prefixIcon: Icon(Icons.location_pin),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Container(
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  "Search",
                  style: TextStyle(color: Colors.white),
                ).tr(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
