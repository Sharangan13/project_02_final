import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Offers extends StatefulWidget {
  @override
  _OffersScreenState createState() => _OffersScreenState();
}

class _OffersScreenState extends State<Offers> {
  final plantsController = TextEditingController();
  final equipmentController = TextEditingController();

  void addOffers() {
    double plantsPercentage = double.parse(plantsController.text);
    double equipmentPercentage = double.parse(equipmentController.text);


    // Update the offers percentages in the existing document in Firestore
    FirebaseFirestore.instance.collection('offers').doc('percentages').set({
      'plantsPercentage': plantsPercentage,
      'equipmentPercentage': equipmentPercentage,
    }, SetOptions(merge: true)).then((value) {
      plantsController.clear();
      equipmentController.clear();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Offers Added'),
          content: Text('The offers percentages have been successfully added!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to add the offers percentages. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Offers Percentages'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: plantsController,
              decoration: InputDecoration(labelText: 'Plants Percentage Off'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 16),
            TextField(
              controller: equipmentController,
              decoration: InputDecoration(labelText: 'Equipment Percentage Off'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: addOffers,
              child: Text('Add Offers'),
            ),
          ],
        ),
      ),
    );
  }
}