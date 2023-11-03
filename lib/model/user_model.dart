import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String fullName;
  final String email;
  final String role;

  const UserModel(
      {this.id,
      required this.fullName,
      required this.email,
      required this.role});

  toJson() {
    return {"FullName": fullName, "Email": email, "Role": role};
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;

    return UserModel(
        id: document.id,
        fullName: data["FullName"],
        email: data["Email"],
        role: data["Role"]);
  }
}
