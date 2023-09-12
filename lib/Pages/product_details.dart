import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Product.dart';
import 'cart.dart';

class Booking {
  String status;
  final String category;
  final String image_url;
  final String name;
  final double total;
  final int quantity;
  var email;
  String? bookingId;
  String? productId;

  Booking({
    required this.status,
    required this.category,
    required this.image_url,
    required this.name,
    required this.total,
    required this.quantity,
    required this.email,
    this.bookingId,
    this.productId,
  });

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'image_url': image_url,
      'name': name,
      'total': total * quantity,
      'quantity': quantity,
      'status': status,
      'UserEmail': email,
      'bookingId': bookingId,
      'productId': productId,
    };
  }
}

class BookingService {
  final user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> bookProduct(Booking booking) async {
    try {
      final DocumentReference docRef = await _firestore
          .collection('Booking')
          .doc(user!.uid) // Use user.uid here
          .collection("UserBooking")
          .add(booking.toMap());

      final bookingId = docRef.id;
      booking.bookingId = bookingId;

      // Update the 'bookingId' field in Firestore
      await docRef.update({'bookingId': bookingId});

      return bookingId;
    } catch (e) {
      print('Error booking product: $e');
      // Handle the error as needed
    }
  }
}

class ProductDetails extends StatefulWidget {
  final Product product;

  const ProductDetails({required this.product});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int selectedQuantity = 1;

  void _addToCart() {
    Cart.addToCart(widget.product, selectedQuantity);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} added to cart.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showImageInFullScreen() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Image.network(
            widget.product.imageURL,
            fit: BoxFit.contain,
          ),
        );
      },
    );
  }

  Future<void> _updateProductQuantities(
      Product product, int bookedQuantity) async {
    final firestore = FirebaseFirestore.instance;
    final batch = firestore.batch();
    DocumentReference?
        productDoc; // Declare productDoc outside the if-else block

    try {
      if (widget.product.Category.trim() == "equipments") {
        productDoc = firestore
            .collection('Equipments')
            .doc("equipments")
            .collection('Items')
            .doc(product.productId);
      } else {
        productDoc = firestore
            .collection('Plants')
            .doc(widget.product.Category)
            .collection('Items')
            .doc(product.productId);
      }

      final docSnapshot = await productDoc.get();

      if (docSnapshot.exists) {
        // Get the current available quantity from the Firestore document
        int currentAvailableQuantity =
            int.parse(docSnapshot['quantity'] ?? '0');

        // Calculate the new available quantity after deducting the selected quantity
        int newAvailableQuantity = currentAvailableQuantity - bookedQuantity;

        // Add the update operation to the batch
        batch.update(productDoc, {'quantity': newAvailableQuantity.toString()});

        // Update the product's availableQuantity property in memory to reflect the change
        product.quantity = newAvailableQuantity;
      }
    } catch (error) {
      print('Error updating quantity for ${product.name}: $error');
      // Handle the error as needed
    }

    // Commit the batch write
    try {
      await batch.commit();
    } catch (error) {
      print('Error committing batch write: $error');
      // Handle the error as needed
    }
  }

  void _handleBookNow() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user != null) {
      final Booking booking = Booking(
          status: "pending",
          category: widget.product.Category,
          image_url: widget.product.imageURL,
          name: widget.product.name,
          total: widget.product.price * selectedQuantity,
          quantity: selectedQuantity,
          email: user.email,
          productId: widget.product.productId);

      final confirmed = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Booking'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Are you sure you want to book $selectedQuantity  ${widget.product.name}?',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop(false); // Return false to indicate cancellation
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context)
                      .pop(true); // Return true to indicate confirmation
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: Text('Book'),
              ),
            ],
          );
        },
      );

      if (confirmed == true) {
        try {
          final BookingService bookingService = BookingService();
          await bookingService.bookProduct(booking);

          // Update the product quantity in Firestore and in memory
          await _updateProductQuantities(widget.product, selectedQuantity);

          // Show the success message using ScaffoldMessenger
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Successfully booked $selectedQuantity ${widget.product.name}',
              ),
              duration: Duration(seconds: 2),
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error booking ${widget.product.name}'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = selectedQuantity * widget.product.price;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        children: [
          GestureDetector(
            onTap: _showImageInFullScreen,
            child: Container(
              height: 300.0,
              child: GridTile(
                child: Container(
                  color: Colors.white,
                  child: Image.network(
                    widget.product.imageURL,
                    fit: BoxFit.cover,
                  ),
                ),
                footer: Container(
                  color: Colors.white70,
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'Price: Rs ${widget.product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        '${widget.product.quantity} Available',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: selectedQuantity,
                  onChanged: (newValue) {
                    setState(() {
                      selectedQuantity = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    hintText: 'Select Quantity',
                  ),
                  items: List.generate(
                    widget.product.quantity.toInt(),
                    (index) => DropdownMenuItem<int>(
                      value: index + 1,
                      child: Text('${index + 1}'),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.0),
            ],
          ),
          SizedBox(height: 16.0),
          Text(
            'Total Amount: Rs ${totalAmount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _handleBookNow,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    elevation: 0.2,
                  ),
                  child: Text("Book Now"),
                ),
              ),
              IconButton(
                onPressed: _addToCart,
                icon: Icon(Icons.add_shopping_cart),
                color: Colors.green,
              ),
            ],
          ),
          Divider(color: Colors.green),
          ListTile(
            title: Text(
              "Description",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              widget.product.description,
            ),
          ),
        ],
      ),
    );
  }
}
