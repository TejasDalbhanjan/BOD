import 'package:BOD/dd.dart';
import 'package:BOD/places.dart';
import 'package:BOD/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
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
  final _scrollController = ScrollController();

  final List<String> select = ["-", "Blood", "Organ"];

  final List<String> blood = ["-", "O+", "O-", "AB+"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        title: Text('Blood').tr(),
        backgroundColor: Colors.red,
      ),
      drawer: ADrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "SelectType".tr(),
                border: OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.red),
                ),
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
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => BloodD()));
                  } else if (value == "Organ") {
                    Navigator.pushReplacement(context,
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
              decoration: InputDecoration(
                labelText: "Blood".tr(),
                border: OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.red),
                ),
              ),
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
              height: 15,
            ),
            Row(
              children: [
                Text(
                  "SearchLoc",
                  textAlign: TextAlign.left,
                ).tr(),
                SizedBox(
                  width: 160,
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
            SearchInjector(
              child: SafeArea(
                child: Consumer<LocationApi>(
                  builder: (_, api, child) => SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            child: TextField(
                              controller: api.addressController,
                              decoration: InputDecoration(
                                labelText: "Search".tr(),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.search),
                                  onPressed: null,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: new BorderSide(color: Colors.red),
                                ),
                                prefixIcon: Icon(Icons.location_pin),
                              ),
                              onChanged: api.handleSearch,
                            ),
                          ),
                          DropdownMenuItem(
                            child: StreamBuilder<List<Place>>(
                              stream: api.controllerOut,
                              builder: (context, snapshot) {
                                if (snapshot.data == null) {
                                  return Center(
                                      child: Text('No data address found'));
                                }
                                final data = snapshot.data;
                                print(data);
                                return Scrollbar(
                                  controller: _scrollController,
                                  child: SingleChildScrollView(
                                    controller: _scrollController,
                                    child: Container(
                                      child: Builder(
                                        builder: (context) {
                                          return Column(
                                            children: List.generate(
                                              data.length,
                                              (index) {
                                                final place = data[index];
                                                return ListTile(
                                                  onTap: () {
                                                    api.addressController.text =
                                                        '${place.name},${place.street},${place.locality}, ${place.country}';
                                                    print(api.addressController
                                                        .text);
                                                  },
                                                  title: Text(
                                                      '${place.name},${place.street}'),
                                                  subtitle: Text(
                                                      '${place.locality},${place.country}'),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchInjector extends StatelessWidget {
  final Widget child;

  const SearchInjector({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocationApi(),
      child: child,
    );
  }
}

class View extends StatefulWidget {
  View({Key key}) : super(key: key);

  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
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
                return Card(
                  //elevation: 5,
                  shadowColor: Colors.red,
                  child: ListTile(
                    title: Text(
                      list[i]['name'],
                    ),
                    subtitle: Text(list[i]['email']),
                  ),
                );
              },
              itemCount: list.length,
            );
          }
        },
      ),
    );
  }
}
