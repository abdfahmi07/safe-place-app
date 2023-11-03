import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_place_app/model/user_model.dart';

class LoginViewModel with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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

  Future<UserModel> signInWithEmailAndPassword() async {
    try {
      if (formKey.currentState!.validate()) {
        final UserCredential credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passwordController.text.trim());
        await credential.user!.getIdToken();

        final UserModel userData = await getCurrentUser();

        if (credential.user != null) {
          return userData;
        }
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (err.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      }
    } catch (err) {
      throw Exception(err);
    }

    throw Exception('Login Error');
  }
}
