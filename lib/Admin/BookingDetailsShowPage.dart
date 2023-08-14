import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingDetailsPage extends StatefulWidget {
  final String qrCode;

  BookingDetailsPage({required this.qrCode});

  @override
  _BookingDetailsPageState createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  late Future<List<Map<String, dynamic>>> _bookingDataList;

  @override
  void initState() {
    super.initState();
    _bookingDataList = fetchBookingData();
  }

  Future<List<Map<String, dynamic>>> fetchBookingData() async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('ConsultancyBooking')
            .doc(widget.qrCode)
            .collection('Booking')
            .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Convert each DocumentSnapshot to a Map and create a list
      return querySnapshot.docs.map((doc) => doc.data()!).toList();
    } else {
      return []; // Return an empty list if no data is found
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _bookingDataList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error fetching data',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            );
          } else if (snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No booking data found',
                style: TextStyle(fontSize: 18),
              ),
            );
          } else {
            final bookingDataList = snapshot.data!;
            return ListView.builder(
              itemCount: bookingDataList.length,
              itemBuilder: (context, index) {
                final bookingData = bookingDataList[index];
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(
                      'Name: ${bookingData['name']}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text(
                          'Date: ${bookingData['selectedDate']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Time: ${bookingData['selectedTime']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Contact: ${bookingData['contact']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Email: ${bookingData['email']}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Handle complete button action here
                      },
                      child: Text('Complete'),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
