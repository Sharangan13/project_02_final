import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? uid;
  final String username;
  final String email;
  final String phonenumber;
  final String? downloadUrl;
  final String? ProfileUrl;

  const UserModel({
    this.uid,
    required this.username,
    required this.email,
    required this.phonenumber,
    this.downloadUrl,
    this.ProfileUrl,
  });

  toJson() {
    return {
      "uid": uid,
      "UserName": username,
      "Email": email,
      "PhoneNumber": phonenumber,
      "qrCodeUrl": downloadUrl,
      "ProfileUrl": ProfileUrl
    };
  }

  // Step 1- Map user fetched from Firebase to UserModel

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;

    return UserModel(
      uid: document.id,
      email: data["Email"],
      username: data["UserName"],
      phonenumber: data["PhoneNumber"],
    );
  }
}
