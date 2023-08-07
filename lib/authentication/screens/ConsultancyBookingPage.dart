import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'EnterDetailsPage.dart';

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String selectedTime = '';
  DateTime selectedDate = DateTime.now();
  String uid = '';

  Widget _buildTimeButton(String time, Future<bool> isAvailableFuture) {
    return FutureBuilder<bool>(
      future: isAvailableFuture,
      builder: (context, snapshot) {
        bool isAvailable = snapshot.data ?? false;
        return ElevatedButton(
          onPressed: isAvailable
              ? () {
                  setState(() {
                    selectedTime = time;
                  });
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedTime == time ? Colors.blue : null,
          ),
          child: Text(time),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime firstDate = now;
    if (now.weekday == DateTime.sunday) {
      // If today is Sunday, set the first selectable date to Monday
      firstDate = now.add(Duration(days: 1));
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.isBefore(firstDate) ? firstDate : selectedDate,
      firstDate: firstDate,
      lastDate: firstDate.add(Duration(days: 365)),
      selectableDayPredicate: (DateTime day) {
        // Disable selection of Sundays
        return day.weekday != DateTime.sunday;
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        // Reset selectedTime when a new date is selected
        selectedTime = '';
      });
    }
  }

  void _showEnterDetailsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EnterDetailsPage(
          selectedDate: selectedDate,
          selectedTime: selectedTime,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultancy Service Booking'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select a Date:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text('Pick a date'),
            ),
            SizedBox(height: 50),
            Text(
              'Select a Time Period:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTimeButton(
                      '8AM - 10AM',
                      _isTimeSlotAvailable('8AM - 10AM'),
                    ),
                    _buildTimeButton(
                      '10AM - 12PM',
                      _isTimeSlotAvailable('10AM - 12PM'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTimeButton(
                      '1PM - 3PM',
                      _isTimeSlotAvailable('1PM - 3PM'),
                    ),
                    _buildTimeButton(
                      '3PM - 5PM',
                      _isTimeSlotAvailable('3PM - 5PM'),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (selectedTime.isNotEmpty && selectedDate != null) {
                  // Ensure both time and date are selected
                  if (selectedDate.weekday == DateTime.sunday) {
                    // Check if selected date is Sunday
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Invalid Date'),
                          content:
                              Text('Sundays are not available for booking.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close the dialog
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    _checkTimeslotAvailability();
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Select Time Slot and Date'),
                        content: Text('Please select a time slot and a date.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkTimeslotAvailability() async {
    // Check availability of selected timeslot
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('ConsultancyBooking')
        .doc(uid)
        .collection("Booking")
        .where('selected_date',
            isEqualTo: selectedDate.toLocal().toString().split(' ')[0])
        .where('selected_time', isEqualTo: selectedTime)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Timeslot is already booked, show dialog to the user
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Timeslot Not Available'),
            content: Text(
                'The selected timeslot is already booked. Please choose another timeslot.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      _showEnterDetailsPage();
    }
  }

  Future<bool> _isTimeSlotAvailable(String time) async {
    // Check the availability of selected time slot based on the selected date
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('ConsultancyBooking')
        .doc(uid)
        .collection("Booking")
        .where('selected_date',
            isEqualTo: selectedDate.toLocal().toString().split(' ')[0])
        .where('selected_time', isEqualTo: time)
        .get();

    return querySnapshot.docs.isEmpty;
  }
}
