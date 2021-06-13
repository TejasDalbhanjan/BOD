import 'package:BOD/model/places.dart';
import 'package:BOD/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/app_drawer.dart';
import 'Blood.dart';
import 'package:easy_localization/easy_localization.dart';

class OrganD extends StatefulWidget {
  @override
  _OrganDState createState() => _OrganDState();
}

class _OrganDState extends State<OrganD> {
  final List<String> organ = ["-", "Eye", "Kidney", "Liver"];
  final List<String> select = ["-", "Blood", "Organ"];
  final _scrollController = ScrollController();

  String selectedoptions = "-";
  String selectedoptions1 = "-";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        title: Text('Organ').tr(),
        backgroundColor: Colors.red,
      ),
      drawer: ADrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 5,
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "SelectType".tr(),
                filled: true,
                fillColor: Colors.grey[350],
                border: OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.red),
                ),
              ),
              elevation: 2,
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
              "SelectOT".tr(),
              textAlign: TextAlign.left,
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Organ".tr(),
                border: OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.red),
                ),
              ),
              elevation: 4,
              hint: Container(
                child: Text("Organ").tr(),
              ),
              items: organ.map((String organ) {
                return DropdownMenuItem<String>(
                  child: Text(organ),
                  value: organ,
                );
              }).toList(),
              value: selectedoptions1,
              onChanged: (value) {
                setState(() {
                  selectedoptions1 = value;
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
                                border: OutlineInputBorder(
                                  borderSide: new BorderSide(color: Colors.red),
                                ),
                                prefixIcon: Icon(Icons.location_pin),
                              ),
                              onChanged: api.handleSearch,
                            ),
                          ),
                          Container(
                            color: Colors.blue[100].withOpacity(.3),
                            width: MediaQuery.of(context).size.width,
                            height: 150,
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
                                        child: Builder(builder: (context) {
                                          return Column(
                                              children: List.generate(
                                                  data.length, (index) {
                                            final place = data[index];
                                            return ListTile(
                                              onTap: () {
                                                api.addressController.text =
                                                    '${place.name}, ${place.street},${place.locality}, ${place.country}';
                                                print(
                                                    api.addressController.text);
                                              },
                                              title: Text(
                                                  '${place.name},${place.street}'),
                                              subtitle: Text(
                                                  '${place.locality},${place.country}'),
                                            );
                                          }));
                                        }),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                child: RaisedButton(
                  onPressed: () {},
                  child: Text(
                    "Search".tr(),
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.red[500],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void search(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return ListView.builder(itemBuilder: (context, index) {
            return ListTile();
          });
        });
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
