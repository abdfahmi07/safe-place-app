import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_place_app/model/user_model.dart';

class RegisterViewModel with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<UserCredential> signUpWithEmailAndPassword() async {
    try {
      if (formKey.currentState!.validate()) {
        final user = UserModel(
            fullName: nameController.text.trim(),
            email: emailController.text.trim(),
            role: "user");
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        createUser(user);

        return credential;
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (err.code == 'email-already-in-use') {
        throw Exception('The account already exists for that email.');
      }
    } catch (err) {
      throw Exception(err);
    }

    throw Exception('Register Error');
  }

  Future<void> createUser(UserModel user) async {
    try {
      await _db.collection("Users").add(user.toJson());
    } catch (err) {
      throw Exception('Create User Error');
    }
  }
}
