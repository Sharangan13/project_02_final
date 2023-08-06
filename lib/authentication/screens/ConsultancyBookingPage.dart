import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

class EnterDetailsPage extends StatefulWidget {
  final DateTime selectedDate;
  final String selectedTime;

  EnterDetailsPage({required this.selectedDate, required this.selectedTime});

  @override
  _EnterDetailsPageState createState() => _EnterDetailsPageState();
}

class _EnterDetailsPageState extends State<EnterDetailsPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();

  bool _validatePhoneNumber(String value) {
    // Regular expression to check for 10-digit phone number without any special characters
    RegExp regex = RegExp(r'^[0-9]{10}$');
    return regex.hasMatch(value);
  }

  void _saveBooking() {
    String name = nameController.text;
    String contact = contactController.text;

    if (!_validatePhoneNumber(contact)) {
      // Invalid phone number format
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Invalid Phone Number'),
            content: Text('Please enter a valid 10-digit phone number.'),
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
      return;
    }

    // Get the current user's UID
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    // Save the booking details to Firestore
    FirebaseFirestore.instance
        .collection('ConsultancyBooking')
        .doc(uid)
        .collection("Booking")
        .add({
      'name': name,
      'contact': contact,
      'selected_date': widget.selectedDate.toLocal().toString().split(' ')[0],
      'selected_time': widget.selectedTime,
      'uid': uid,
    }).then((value) {
      // Booking data saved successfully
      print('Booking data saved to Firestore!');
      _showSuccessDialog(); // Show success dialog
      _resetFields(); // Clear all fields
      // Refresh the user's bookings list after saving a new booking
      // Call the function to fetch user bookings here (e.g., fetchUserBookings())
    }).catchError((error) {
      // Error occurred while saving the booking data
      print('Error saving booking data: $error');
      // You can also show an error message using a dialog here if needed
    });
  }

  // Show success dialog
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Booking Successful'),
          content: Text('Your booking has been successfully saved.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pop(context); // Close this page
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _resetFields() {
    nameController.text = '';
    contactController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Selected Date:  ${widget.selectedDate.toLocal().toString().split(' ')[0]}',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700]),
              ),
              SizedBox(height: 10),
              Text(
                'Selected Time Slot:  ${widget.selectedTime}',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700]),
              ),
              SizedBox(height: 40),
              Text(
                'Enter Your Name:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Your name',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text(
                'Enter Your Contact Number:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: contactController,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: 'Your contact Number',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveBooking,
                child: Text('Book Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
