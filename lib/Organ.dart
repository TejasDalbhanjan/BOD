import 'package:BOD/BList.dart';
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
  TextEditingController selectController = TextEditingController();
  final _scrollController = ScrollController();

  void _showModal(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton(
                      onPressed: () {
                        setState(() {
                          selectController.text = "Heart";
                          Navigator.of(context).pop();
                        });
                      },
                      child: Text(
                        "Heart",
                        style: TextStyle(
                            color: Colors.white70, fontWeight: FontWeight.bold),
                      ),
                      color: Colors.blue,
                      elevation: 8,
                      hoverColor: Colors.white,
                      highlightColor: Colors.red,
                    ),
                    RaisedButton(
                      onPressed: () {
                        setState(() {
                          selectController.text = "Lungs";
                          Navigator.of(context).pop();
                        });
                      },
                      child: Text(
                        "Lungs",
                        style: TextStyle(
                            color: Colors.white70, fontWeight: FontWeight.bold),
                      ),
                      color: Colors.blue,
                      elevation: 8,
                      hoverColor: Colors.white,
                      highlightColor: Colors.red,
                    ),
                    RaisedButton(
                      onPressed: () {
                        setState(() {
                          selectController.text = "Liver";
                          Navigator.of(context).pop();
                        });
                      },
                      child: Text(
                        "Liver",
                        style: TextStyle(
                            color: Colors.white70, fontWeight: FontWeight.bold),
                      ),
                      color: Colors.blue,
                      elevation: 8,
                      hoverColor: Colors.white,
                      highlightColor: Colors.red,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton(
                      onPressed: () {
                        setState(() {
                          selectController.text = "Kidney";
                          Navigator.of(context).pop();
                        });
                      },
                      child: Text(
                        "Kidney",
                        style: TextStyle(
                            color: Colors.white70, fontWeight: FontWeight.bold),
                      ),
                      color: Colors.blue,
                      elevation: 8,
                      hoverColor: Colors.white,
                      highlightColor: Colors.red,
                    ),
                    RaisedButton(
                      onPressed: () {
                        setState(() {
                          selectController.text = "Eyes";
                          Navigator.of(context).pop();
                        });
                      },
                      child: Text(
                        "Eyes",
                        style: TextStyle(
                            color: Colors.white70, fontWeight: FontWeight.bold),
                      ),
                      color: Colors.blue,
                      elevation: 8,
                      hoverColor: Colors.white,
                      highlightColor: Colors.red,
                    ),
                    RaisedButton(
                      onPressed: () {
                        setState(() {
                          selectController.text = "Intestine";
                          Navigator.of(context).pop();
                        });
                      },
                      child: Text(
                        "Intestine",
                        style: TextStyle(
                            color: Colors.white70, fontWeight: FontWeight.bold),
                      ),
                      color: Colors.blue,
                      elevation: 8,
                      hoverColor: Colors.white,
                      highlightColor: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              readOnly: true,
              onTap: () => _showModal(context),
              controller: selectController,
              decoration: InputDecoration(
                labelText: "Organ".tr(),
                hintText: "Organ".tr(),
                border: OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.red),
                ),
              ),
            ),
            Center(
              child: RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => View()));
                },
                child: Text(
                  "Search".tr() + " " + "in all Location",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.red[500],
              ),
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
            RaisedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => View()));
              },
              child: Text(
                "Search".tr(),
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.red[500],
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
