import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Hospital {
  String name;
  String address;
  Hospital(this.name, this.address);

  Hospital.fromSnapshot(DocumentSnapshot snapshot) {
    name = snapshot['name'];
    address = snapshot['address'];
  }
}
