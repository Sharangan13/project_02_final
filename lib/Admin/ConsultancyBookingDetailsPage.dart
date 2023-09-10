import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting

class ConsultancyBookingDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultancy Booking Details (Admin)'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collectionGroup('Booking') // Root collection
            .snapshots(), // Fetch all documents in the 'ConsultancyBooking' collection
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No booking details found.'),
            );
          }

          final bookingDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: bookingDocs.length,
            itemBuilder: (context, index) {
              final bookingData =
              bookingDocs[index].data() as Map<String, dynamic>;

              // Extract the specific fields you want to display
              final contact = bookingData['contact'];
              final name = bookingData['name'];

              // Check if the Firestore fields might be null
              final selectedDate = bookingData['selected_date'] ;
              final selectedTime = bookingData['selected_time'] as String?;
              print('Selected Date Timestamp: $selectedDate');
              print('Selected Time: $selectedTime');


              // Convert the Firestore timestamp to a formatted date if it's not null
              String formattedDate = 'N/A';
              if (selectedDate != null) {
                formattedDate = DateFormat('MM-dd-yyyy').format(selectedDate);
              }

              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('Contact: $contact'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: $name'),
                      Text('Date: $formattedDate'),
                      Text('Time: ${selectedTime ?? 'N/A'}'), // Use 'N/A' if selectedTime is null

                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
