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
  User? user;
  double rating = 0.0;
  String comment = '';
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize Firebase once in the initState
    Firebase.initializeApp().whenComplete(() {
      setState(() {
        user = FirebaseAuth.instance.currentUser;
      });
    });
    // Load ratings when the screen is initialized
    loadRatings();
  }

  List<RatingItem> recentRatings = [];

  Future<void> loadRatings() async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Fetch recent ratings data from Firestore (including user's own ratings)
      final querySnapshot = await firestore
          .collection('ratings')
          .orderBy('timestamp', descending: true)
          .get();

      final List<RatingItem> loadedRecentRatings = [];
      for (final doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        loadedRecentRatings.add(RatingItem(
          userId: data['userId'],
          rating: data['rating'].toDouble(),
          comment: data['comment'] ?? '',
        ));
      }

      // Reverse the order of recentRatings to display recent ratings at the top
      loadedRecentRatings.sort((a, b) => b.timestamp!.compareTo(a.timestamp!));

      // Update the state to display the loaded recent ratings
      setState(() {
        recentRatings = loadedRecentRatings;
      });
    } catch (e) {
      print('Error loading ratings: $e');
      // Optionally show an error message if there's an issue loading ratings
    }
  }

  // Widget to display a single rating item
  Widget buildRatingItem(RatingItem item) {
    return ListTile(
      title: Text('Rating: ${item.rating}'),
      subtitle: Text(item.comment ?? ''),
    );
  }

  void submitRating() async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Save the rating and comment data to Firestore
      await firestore.collection('ratings').add({
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

      // Refresh the recent ratings list after submitting a new rating
      loadRatings();
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
            ),
            SizedBox(height: 16.0),
            Text(
              'Recent Ratings:',
              style: TextStyle(fontSize: 18.0),
            ),
            // Display the list of recent ratings
            Expanded(
              child: ListView.builder(
                itemCount: recentRatings.length,
                itemBuilder: (context, index) {
                  return buildRatingItem(recentRatings[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RatingItem {
  final String? userId;
  final double? rating;
  final String? comment; // Comment is still nullable
  final Timestamp? timestamp;

  RatingItem({
    this.userId,
    this.rating,
    required this.comment,
    this.timestamp,
  });
}
