import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SeeOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('See Orders'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collectionGroup("UserBooking").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No Orders',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot userBookingDocument = snapshot.data!.docs[index];
              // Assuming you have a model class for your orders
              // Replace 'YourOrderModel' with your actual model class
              YourOrderModel order = YourOrderModel(
                userEmail: userBookingDocument['UserEmail'],
                category: userBookingDocument['category'],
                imageUrl: userBookingDocument['image_url'],
                name: userBookingDocument['name'],
                quantity: userBookingDocument['quantity'],
                status: userBookingDocument['status'],
              );

              // Render your order details here, including the image
              return ListTile(
                title: Text('User Email: ${order.userEmail}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Category: ${order.category}'),
                    Text('Name: ${order.name}'),
                    Text('Quantity: ${order.quantity}'),
                    Text('Status: ${order.status}'),
                  ],
                ),
                leading: Image.network(order.imageUrl ?? ''), // Display the product image
                // Add other fields here
              );
            },
          );
        },
      ),
    );
  }
}

class YourOrderModel {
  final String? userEmail;
  final String? category;
  final String? imageUrl;
  final String? name;
  final int? quantity;
  final String? status;

  YourOrderModel({
    this.userEmail,
    this.category,
    this.imageUrl,
    this.name,
    this.quantity,
    this.status,
  });
}
