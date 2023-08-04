import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RateUsScreen extends StatefulWidget {
  final String uid;

  RateUsScreen({required this.uid});

  @override
  _RateUsScreenState createState() => _RateUsScreenState();
}

class _RateUsScreenState extends State<RateUsScreen> {
  final user = FirebaseAuth.instance.currentUser;
  double rating = 0.0;
  String comment = '';
  final TextEditingController _commentController = TextEditingController();

  void submitRating() async {
    try {
      // Initialize Firebase and Firestore if not already initialized
      await Firebase.initializeApp();
      final firestore = FirebaseFirestore.instance;

      // Save the rating and comment data to Firestore
      await firestore
          .collection('ratings')
          .doc(user?.uid)
          .collection("user")
          .add({
        'userId': user?.uid,
        'rating': rating,
        'comment': comment,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Show a pop-up message when the rating is submitted
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Rating Submitted'),
            content: Text(
                'Thank you for your feedback! Your rating has been submitted.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  // Close the dialog
                  Navigator.of(context).pop();
                  // Clear the comment field after submission
                  setState(() {
                    _commentController.clear();
                  });
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error saving rating: $e');
      // Optionally show an error message if there's an issue saving the rating
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rate Us'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Rate our Plant Management and Consultancy Services:',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Display rating stars
                for (int i = 1; i <= 5; i++)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        rating = i.toDouble();
                      });
                    },
                    child: Icon(
                      i <= rating.floor() ? Icons.star : Icons.star_border,
                      color: Colors.yellow,
                      size: 40.0,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Leave a comment',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  comment = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () {
                submitRating(); // Call the submitRating method when the button is pressed
              },
            )
          ],
        ),
      ),
    );
  }
}
