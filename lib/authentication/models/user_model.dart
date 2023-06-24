import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String username;
  final String email;
  final String phonenumber;
  final String password;

  const UserModel({
    this.id,
    required this.username,
    required this.email,
    required this.phonenumber,
    required this.password,
  });

  toJson() {
    return {
      "UserName": username,
      "Email": email,
      "PhoneNumber": phonenumber,
      "Password": password,
    };
  }

  // Step 1- Map user fetched from Firebase to UserModel

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;

    return UserModel(
      id: document.id,
      email: data["Email"],
      password: data["Password"],
      username: data["UserName"],
      phonenumber: data["PhoneNumber"],
    );
  }
}
