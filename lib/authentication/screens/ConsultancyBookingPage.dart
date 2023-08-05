import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String selectedTime = '';
  DateTime selectedDate = DateTime.now();
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  List<Map<String, dynamic>> bookings = [];

  final User? currentUser = FirebaseAuth.instance.currentUser; //firebase_auth

  Widget _buildTimeButton(String time) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedTime = time;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedTime == time ? Colors.blue : null,
      ),
      child: Text(time),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

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
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _resetFields() {
    setState(() {
      selectedDate = DateTime.now();
      selectedTime = '';
      nameController.clear();
      contactController.clear();
    });
  }

  bool _validatePhoneNumber(String value) {
    // Regular expression to check for 10-digit phone number without any special characters
    RegExp regex = RegExp(r'^[0-9]{10}$');
    return regex.hasMatch(value);
  }

  Future<void> fetchUserBookings() async {
    String? userId = currentUser?.uid;// Replace with actual user ID if you have authentication
    // Get the reference to the user's document
    DocumentReference<Map<String, dynamic>> userRef = FirebaseFirestore.instance.collection('ConsultancyBooking').doc(userId);
    // Get the reference to the user's bookings sub-collection
    CollectionReference<Map<String, dynamic>> bookingsRef = userRef.collection('bookings');
    // Fetch all bookings for the current user where the selected date is greater than or equal to today
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await bookingsRef.where('selected_date', isGreaterThanOrEqualTo: DateTime.now()).get();
    setState(() {
      bookings = querySnapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  void _saveBookingToFirestore() {
    String? userId = currentUser?.uid; // Replace with actual user ID if you have authentication
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

    // Get the reference to the user's document
    DocumentReference userRef = FirebaseFirestore.instance.collection('ConsultancyBooking').doc(userId);

    // Get the reference to the user's bookings sub-collection
    CollectionReference bookingsRef = userRef.collection('bookings');

    // Check if the selected time block is already booked for the selected date
    bookingsRef
        .where('uid', isEqualTo: currentUser!.uid)// new added
        .where('selected_date', isEqualTo: selectedDate)
        .where('selected_time', isEqualTo: selectedTime)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        // Time block already booked for the selected date
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Time Slot Taken'),
              content: Text('The selected time slot is already booked for this date. Please choose another time.'),
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
        // Time block available, proceed with booking
        // Add the booking details as a new document in the "bookings" sub-collection
        bookingsRef.add({

          'name': name,
          'contact': contact,
          'selected_date': selectedDate,
          'selected_time': selectedTime,
        }).then((value) {
          // Booking data saved successfully
          print('Booking data saved to Firestore!');
          _showSuccessDialog(); // Show success dialog
          _resetFields(); // Clear all fields
          // Refresh the user's bookings list after saving a new booking
          fetchUserBookings();
        }).catchError((error) {
          // Error occurred while saving the booking data
          print('Error saving booking data: $error');
          // You can also show an error message using a dialog here if needed
        });
      }
    }).catchError((error) {
      // Error occurred while checking for existing bookings
      print('Error checking for existing bookings: $error');
      // You can also show an error message using a dialog here if needed
    });
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
            SizedBox(height: 20),
            Text(
              'Select a Time Period:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTimeButton('8-10'),
                _buildTimeButton('10-12'),
                _buildTimeButton('1-3'),
                _buildTimeButton('3-5'),
              ],
            ),
            SizedBox(height: 20),
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
              decoration: InputDecoration(
                hintText: '077*******',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add your booking logic here
                // You can use the selectedDate, selectedTime, name, and contact variables
                // to handle the booking request.
                _saveBookingToFirestore();
              },
              child: Text('Book Now'),
            ),
            SizedBox(height: 20),
            Text(
              'Your Bookings:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> booking = bookings[index];
                  String bookingDate = booking['selected_date'].toDate().toString();
                  String bookingTime = booking['selected_time'];
                  return ListTile(
                    title: Text('Booking on $bookingDate at $bookingTime'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
