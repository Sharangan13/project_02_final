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

  Future<void> deleteBookingDetail(String bookingId) async {
    try {
      await FirebaseFirestore.instance
          .collection('ConsultancyBooking')
          .doc(widget.qrCode)
          .collection('Booking')
          .doc(bookingId)
          .delete();

      // Refresh the list of booking data after deletion
      setState(() {
        _bookingDataList = fetchBookingData();
      });
    } catch (e) {
      print('Error deleting booking detail: $e');
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
                final bookingId = snapshot.data![index]
                    ['id']; // Use the bookingId from the data

                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          'Name: ${bookingData['name']}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Show a confirmation dialog
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Confirm Completion',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    content: Text(
                                        'Are you sure you want to mark this booking as complete?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          // Handle complete button action here
                                          deleteBookingDetail(bookingId);
                                        },
                                        child: Text(
                                          'Yes',
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(
                                              context); // Close the dialog
                                        },
                                        child: Text(
                                          'No',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.green, // Change button color
                            ),
                            child: Text(
                              'Complete',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
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
