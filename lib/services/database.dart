import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class Db {
  final CollectionReference user =
      FirebaseFirestore.instance.collection("user");
  final CollectionReference camp =
      FirebaseFirestore.instance.collection("camp");

  final CollectionReference hospitalbloodbank =
      FirebaseFirestore.instance.collection("hospital");

  Future<void> createUserData(
      String name,
      String email,
      String address,
      String age,
      String phone,
      String bloodg,
      String adhar,
      GeoPoint location,
      String tokenId,
      String uid) async {
    return await user.doc(uid).set({
      'uid': uid,
      'tokenId': tokenId,
      'name': name,
      'email': email,
      'address': address,
      'age': age,
      'Phone-No': phone,
      'Blood-Group': bloodg,
      'adhar': adhar,
      'location': location,
    });
  }

  Future<void> createHospitalBBdata(String name, String address,
      String licenseno, GeoPoint location, String uid) async {
    return await hospitalbloodbank.doc(uid).set({
      'uid': uid,
      'name': name,
      'address': address,
      'location': location,
      'Licence_No': licenseno,
    });
  }

  Future<void> createCampdata(
      String name, String address, DateTime date, String uid) async {
    return await camp.doc(uid).set({
      'uid': uid,
      'name': name,
      'address': address,
      'Date- Time': date,
    });
  }

  Future<bool> signOut() async {
    try {
      await _auth.signOut();
      return Future.value(true);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> updateAuth(String email) async {
    return await _auth.currentUser.updateEmail(email);
  }

  Future updateDataUser(String email, String uid) async {
    return await user.doc(uid).update({
      'email': email,
    });
  }

  updateDataHh(String old, Map<String, String> updated) {
    FirebaseFirestore.instance
        .collection("hospital")
        .doc(old)
        .update(updated)
        .catchError((e) {
      print("error");
    });
  }

  Future deleteauth(String id, String pass) async {
    await FirebaseFirestore.instance
        .collection("user")
        .doc(id)
        .delete()
        .catchError((e) {
      print("error");
    });
  }

  getUserdata() async {
    return FirebaseFirestore.instance.collection('user').get();
  }

  gethospital(String id) async {
    return FirebaseFirestore.instance.collection("hospital").doc(id);
  }
}
