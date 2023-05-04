import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DataBase {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  void setData(String email, String name, String city , String category , String age) async {
    _firestore.collection("users").doc(email).set({
      "email": email,
      "name": name,
      "age": age,
      "category": category
    });
  }

    void updateRecData(String email, String place_clicked , Map<String , dynamic> data) async {
    _firestore.collection("users").doc(email).collection('interests').doc(place_clicked).set(data);
  }

}