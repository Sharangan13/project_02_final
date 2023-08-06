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
      final double price = bookingData['price'];
      final int quantity = bookingData['quantity'];
      total += price * quantity;
    }

    return total;
  }
  Future<void> _removeBooking(String bookingId) async {
    final bookingRef = FirebaseFirestore.instance.collection('booking');
    try {
      await bookingRef.doc(bookingId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking removed successfully.'),
          duration: Duration(seconds: 2),
        ),
      );

    } catch (e) {
      print('Error removing booking: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error removing booking.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pre-Orders Bookings'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('booking')
            .where('uid', isEqualTo: currentUser!.uid)
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

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final bookingData = bookings[index].data() as Map<String, dynamic>;
              final bookingId = bookings[index].id;

              return ListTile(
                leading: Image.network(bookingData['image_url']),
                title: Text(bookingData['name']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Category: ${bookingData['category']}'),
                    Text('Price: ${bookingData['price']}'),
                    Text('Quantity: ${bookingData['quantity']}'),
                    Text('uid: ${bookingData['uid']}'),

                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: () => _removeBooking(bookingId),
                  child: Text('Remove Booking'),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('booking')
              .where('uid', isEqualTo: currentUser!.uid)
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            final bookings = snapshot.data!.docs;
            return Text(
              'Total Amount: Rs ${_calculateTotalAmount(bookings).toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ),
    );
  }
}
