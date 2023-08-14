import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemBookingDetailsPage extends StatefulWidget {
  final String qrCode;

  ItemBookingDetailsPage({required this.qrCode});

  @override
  _BookingDetailsPageState createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<ItemBookingDetailsPage> {
  late Future<List<Map<String, dynamic>>> _bookingDataList;

  @override
  void initState() {
    super.initState();
    _bookingDataList = fetchBookingData();
  }

  Future<List<Map<String, dynamic>>> fetchBookingData() async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('Booking')
            .doc(widget.qrCode)
            .collection('UserBooking')
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
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.all(16),
                        leading: Image.network(
                          bookingData['image_url'],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          '${bookingData['name']}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            Text(
                              'Total: ${bookingData['total']}',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Quantity: ${bookingData['quantity']}',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'User email: ${bookingData['UserEmail']}',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Handle complete button action here
                            },
                            child: Text('Complete'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              textStyle: TextStyle(fontSize: 14),
                            ),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              // Handle cancel button action here
                            },
                            child: Text('Cancel'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              textStyle: TextStyle(fontSize: 14),
                            ),
                          ),
                          SizedBox(width: 16),
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
