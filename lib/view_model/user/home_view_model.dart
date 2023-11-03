import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_place_app/model/user_model.dart';

class UserHomeViewModel with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<UserModel> getCurrentUser() async {
    try {
      final userEmail = _auth.currentUser?.email;

      if (userEmail != null) {
        return getUserDetails(userEmail);
      } else {
        throw Exception("Authentication Error");
      }
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<UserModel> getUserDetails(String email) async {
    try {
      final snapshot =
          await _db.collection("Users").where("Email", isEqualTo: email).get();
      final userData =
          snapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).single;

      return userData;
    } catch (err) {
      throw Exception(err);
    }
  }
}
