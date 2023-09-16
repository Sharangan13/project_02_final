import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PreOrderBookingPage extends StatefulWidget {
  @override
  _PreOrderBookingPageState createState() => _PreOrderBookingPageState();
}

class _PreOrderBookingPageState extends State<PreOrderBookingPage> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  double _calculateTotalAmount(List<QueryDocumentSnapshot> bookings) {
    double total = 0;

    for (var bookingData in bookings) {
      double bookingTotal =
          bookingData['total']; // Fetch the total from bookingData

      total += bookingTotal;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pre-Orders Bookings'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Booking')
            .doc(currentUser?.uid)
            .collection("UserBooking")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final bookings = snapshot.data!.docs;

          if (bookings.isEmpty) {
            return Center(
              child: Text('You have no pre-order bookings.'),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final bookingData =
                        bookings[index].data() as Map<String, dynamic>;

                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.all(8),
                      child: ListTile(
                        leading: Image.network(bookingData['image_url']),
                        title: Text(bookingData['name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total: ${bookingData['total']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              'Quantity: ${bookingData['quantity']}',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Total Amount for all bookings: Rs ${_calculateTotalAmount(bookings).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
