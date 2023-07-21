import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);
  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  String? username = null;
  String? email = null;
  String? PhoneNumber = null;
  String? profilePictureURL;
  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final String currentUserEmail = user.email!;
        final QuerySnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('Users')
                .where('Email', isEqualTo: currentUserEmail)
                .limit(1)
                .get();
        if (snapshot.docs.isNotEmpty) {
          final userData = snapshot.docs.first.data();
          setState(() {
            username = userData['UserName'];
            email = userData['Email'];
            PhoneNumber = userData['PhoneNumber'];
            profilePictureURL = userData['ProfilePictureURL'];
          });
        } else {
          setState(() {
            username = null;
            email = null;
            PhoneNumber = null;
            profilePictureURL = null;
          });
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  void changePassword() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final email = user.email;
      if (email != null) {
        try {
          await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Password Reset'),
                content: Text(
                    'A password reset link has been sent to your email. Please follow the instructions to change your password.'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        } catch (e) {
          print('Error sending password reset email: $e');
        }
      }
    }
  }

  Future<void> _uploadProfilePicture() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final File imageFile = File(pickedImage.path);

      try {
        final User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final String currentUserEmail = user.email!;
          final Reference storageReference = FirebaseStorage.instance
              .ref()
              .child('profilePictures/$currentUserEmail.jpg');
          final UploadTask uploadTask = storageReference.putFile(imageFile);
          final TaskSnapshot taskSnapshot =
              await uploadTask.whenComplete(() => null);
          final String downloadURL = await taskSnapshot.ref.getDownloadURL();

          await FirebaseFirestore.instance
              .collection('Users')
              .doc(currentUserEmail)
              .update({'ProfilePictureURL': downloadURL});

          setState(() {
            profilePictureURL = downloadURL;
          });
        }
      } catch (e) {
        print('Error uploading profile picture: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text('My Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              backgroundImage: profilePictureURL != null
                  ? NetworkImage(profilePictureURL!)
                  : null,
              child: profilePictureURL == null
                  ? IconButton(
                      onPressed: _uploadProfilePicture,
                      icon: const Icon(
                        Icons.camera_alt,
                        size: 40,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 20),
            Text(
              'Username: $username',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Email: $email',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'PhoneNumber: $PhoneNumber',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: changePassword,
              child: Text('Change My Password'),
            ),
          ],
        ),
      ),
    );
  }
}
