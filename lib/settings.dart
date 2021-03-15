import 'package:firebase_auth/firebase_auth.dart';
import 'changeL.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'update_P.dart';
import 'editProfile.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'delete.dart';

class Set extends StatelessWidget {
  //FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.redAccent,
        title: Text(
          'Setting',
          style: TextStyle(color: Colors.white),
        ).tr(),
        actions: [
          Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.01)),
          IconButton(
              icon: Icon(Icons.qr_code_scanner_sharp),
              onPressed: () async {
                //await _scan();
              })
        ],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Card(
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    margin: const EdgeInsets.all(8.0),
                    color: Colors.redAccent,
                    child: ListTile(
                      onTap: () {},
                      title: Text(
                        'abc',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      leading: CircleAvatar(
                          //backgroundImage: CachedNetworkImageProvider(avatars[0]),

                          ),
                    )),
                Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Column(children: <Widget>[
                    ListTile(
                        leading: Icon(Icons.edit_off, color: Colors.redAccent),
                        title: Text('Ep').tr(),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Editp()));
                        }),
                    _buildDivider(),
                    ListTile(
                        leading:
                            Icon(Icons.lock_outline, color: Colors.redAccent),
                        title: Text('Changep').tr(),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Update()));
                        }),
                    _buildDivider(),
                    ListTile(
                        leading: Icon(Icons.language, color: Colors.redAccent),
                        title: Text('ChangeL').tr(),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangeL()));
                        }),
                    ListTile(
                        leading: Icon(Icons.delete, color: Colors.redAccent),
                        title: Text('DA').tr(),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Delete()));
                        })
                  ]),
                ),
                SizedBox(
                  height: (20.0),
                ),
                Text(
                  "NotifyS",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ).tr(),
                SizedBox(
                  height: (20.0),
                ),
                SwitchListTile(
                  activeColor: Colors.red,
                  contentPadding: EdgeInsets.all(0),
                  value: true,
                  title: Text("ReciveApp").tr(),
                  onChanged: null,
                ),
                SwitchListTile(
                  dense: true,
                  activeColor: Colors.red,
                  contentPadding: EdgeInsets.all(0),
                  value: true,
                  title: Text("ReciveNotify").tr(),
                  onChanged: (val) {},
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _buildDivider() {
    return Container(
      height: 1.0,
      color: Colors.black,
    );
  }
}
