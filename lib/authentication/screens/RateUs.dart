import 'package:flutter/material.dart';

class RateUsScreen extends StatefulWidget {
  @override
  _RateUsScreenState createState() => _RateUsScreenState();
}

class _RateUsScreenState extends State<RateUsScreen> {
  double rating = 0.0;
  String comment = '';

  void submitRating() {
    // Implement your logic to save the rating and comment to the database or storage solution
    // You can use the 'rating' and 'comment' variables to access the user's input
    // Add your code here to perform any additional actions after submitting the rating
    // For example, displaying a confirmation message or navigating to a different screen
    // You can also add validation and error handling as per your requirements
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( backgroundColor: Colors.green,
        title: Text('Rate Us'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Rate our Plant Management and Consultancy Services:',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Display rating stars
                for (int i = 1; i <= 5; i++)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        rating = i.toDouble();
                      });
                    },
                    child: Icon(
                      i <= rating.floor() ? Icons.star : Icons.star_border,
                      color: Colors.yellow,
                      size: 40.0,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                hintText: 'Leave a comment',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  comment = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () {
                print('Pressed');
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) return Colors.blue;
                    return Colors.green;
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
