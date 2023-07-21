import 'package:flutter/material.dart';

class ConsultancyBookingDetailsPage extends StatelessWidget {
  final String bookingId;

  ConsultancyBookingDetailsPage({required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text('Consultancy Booking Details'),
      ),
      body: Center(
        child: Text(
          'Booking ID: $bookingId',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
