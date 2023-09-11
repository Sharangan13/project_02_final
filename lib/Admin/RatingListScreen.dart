import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RatingListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Ratings'),
      ),
      body: UserRatingsList(),
    );
  }
}

class UserRatingsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('ratings').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show a loading indicator while fetching data
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        print("Number of docs: ${snapshot.data?.docs.length}");
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text(
              'No ratings found.'); // Show a message if no ratings are available
        }

        final ratingsDocs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: ratingsDocs.length,
          itemBuilder: (context, index) {
            final ratingData =
                ratingsDocs[index].data() as Map<String, dynamic>;

            return ListTile(
              title: Text('User ID: ${ratingData['userId']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rating: ${ratingData['rating']}'),
                  Text('Comment: ${ratingData['comment']}'),
                  Text(
                      'Timestamp: ${ratingData['timestamp'].toDate().toString()}'),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
