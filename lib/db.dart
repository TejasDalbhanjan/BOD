import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class Db {
  final CollectionReference user =
      FirebaseFirestore.instance.collection("user");

  final CollectionReference hospitalbloodbank =
      FirebaseFirestore.instance.collection("hospital");

  Future<void> createUserData(String name, String email, String address,
      String age, String adhar, String coordinates, String uid) async {
    return await user.doc(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
      'address': address,
      'age': age,
      'adhar': adhar,
      'Co-ordinates': coordinates
    });
  }

  Future<void> createHospitalBBdata(
      String name, String address, String licenseno, String uid) async {
    return await hospitalbloodbank.doc(uid).set({
      'uid': uid,
      'name': name,
      'address': address,
      'Licence_No': licenseno,
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
}
