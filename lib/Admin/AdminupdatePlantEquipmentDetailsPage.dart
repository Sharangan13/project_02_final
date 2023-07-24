import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AdminPlantEquipmentDetailsPage extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String price;
  final String quantity;
  final String description;

  AdminPlantEquipmentDetailsPage({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.quantity,
    required this.description,
  });

  @override
  _AdminPlantEquipmentDetailsPageState createState() =>
      _AdminPlantEquipmentDetailsPageState();
}

class _AdminPlantEquipmentDetailsPageState
    extends State<AdminPlantEquipmentDetailsPage> {
  late String updatedImageUrl;
  late String updatedName;
  late String updatedPrice;
  late String updatedQuantity;
  late String updatedDescription;
  final ImagePicker _imagePicker = ImagePicker();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    updatedImageUrl = widget.imageUrl;
    updatedName = widget.name;
    updatedPrice = widget.price;
    updatedQuantity = widget.quantity;
    updatedDescription = widget.description;
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await _imagePicker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.name} Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: () {
                  _pickImage(ImageSource
                      .gallery); // Trigger image selection from gallery
                },
                child: _imageFile != null
                    ? Image.file(
                        _imageFile!,
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        updatedImageUrl,
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              initialValue: updatedName,
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: 'Enter the name',
              ),
              onChanged: (value) {
                setState(() {
                  updatedName = value;
                });
              },
            ),
            SizedBox(height: 8.0),
            TextFormField(
              initialValue: updatedPrice,
              decoration: InputDecoration(
                labelText: 'Price',
                hintText: 'Enter the price',
              ),
              onChanged: (value) {
                setState(() {
                  updatedPrice = value;
                });
              },
            ),
            SizedBox(height: 8.0),
            TextFormField(
              initialValue: updatedQuantity,
              decoration: InputDecoration(
                labelText: 'Quantity',
                hintText: 'Enter the quantity',
              ),
              onChanged: (value) {
                setState(() {
                  updatedQuantity = value;
                });
              },
            ),
            SizedBox(height: 8.0),
            TextFormField(
              initialValue: updatedDescription,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Enter the description',
              ),
              onChanged: (value) {
                setState(() {
                  updatedDescription = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Implement the update logic here
                // You can update the Firestore document with the updated field values
                // using Firestore update method or any other preferred method.
                // Remember to handle error cases and show success/failure messages.
                // You can also navigate back to the previous screen after successful update.

                // Example:
                FirebaseFirestore.instance
                    .collection('Plants')
                    .doc(widget.name)
                    .update({
                  'image_url': updatedImageUrl,
                  'name': updatedName,
                  'price': updatedPrice,
                  'quantity': updatedQuantity,
                  'description': updatedDescription,
                }).then((_) {
                  // Update successful
                  // Show success message or navigate back
                  Navigator.pop(context);
                }).catchError((error) {
                  // Update failed
                  // Show error message or handle the error accordingly
                });
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
