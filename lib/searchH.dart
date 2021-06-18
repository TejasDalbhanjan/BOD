import 'package:BOD/model/hospital.dart';
import 'package:BOD/model/map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'screens/app_drawer.dart';
import 'package:easy_localization/easy_localization.dart';

class SearchH extends StatefulWidget {
  final User user;
  const SearchH({Key key, this.user}) : super(key: key);

  State createState() => new SearchHState();
}

class SearchHState extends State<SearchH> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController _searchController = TextEditingController();

  Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = availableHospitals();
  }

  _onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    var showResults = [];

    if (_searchController.text != "") {
      for (var tripSnapshot in _allResults) {
        var title = Hospital.fromSnapshot(tripSnapshot).name.toLowerCase();

        if (title.contains(_searchController.text.toLowerCase())) {
          showResults.add(tripSnapshot);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  availableHospitals() async {
    var data = await FirebaseFirestore.instance.collection('hospital').get();
    setState(() {
      _allResults = data.docs;
    });
    searchResultsList();
    return "complete";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('BOP'),
        backgroundColor: Colors.red,
      ),
      drawer: ADrawer(user: _auth.currentUser),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Center(
            child: Text(
              "Db",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ).tr(),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "SearchH".tr(),
                border: OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.red),
                ),
                prefixIcon: Icon(Icons.location_pin),
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: _resultsList.length,
            itemBuilder: (BuildContext context, int index) =>
                buildCard(context, _resultsList[index]),
          )),
        ],
      ),
    );
  }
}

Widget buildCard(BuildContext context, DocumentSnapshot document) {
  final hos = Hospital.fromSnapshot(document);
  return Card(
    elevation: 8,
    child: ListTile(
      contentPadding: EdgeInsets.all(20),
      leading: IconButton(
          icon: Icon(Icons.directions),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Mapp()),
            );
          }),
      title: Text(
        hos.name,
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w900, fontSize: 20),
      ),
      subtitle: Text(hos.address),
      onTap: () {},
    ),
  );
}
