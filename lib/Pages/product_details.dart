import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Product.dart';
import 'cart.dart';

class Booking {
  final String uid;
  final String category;
  final String image_url;
  final String name;
  final double price;
  final int quantity;

  Booking({
    required this.uid,
    required this.category,
    required this.image_url,
    required this.name,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'category': category,
      'image_url': image_url,
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }
}

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> bookProduct(Booking booking) async {
    try {
      await _firestore.collection('booking').add(booking.toMap());
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
  void _handleBookNow() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user != null) {
      final Booking booking = Booking(
        uid: user.uid, // Automatically retrieve user's UID
        category: widget.product.Category,
        image_url: widget.product.imageURL,
        name: widget.product.name,
        price: widget.product.price,
        quantity: selectedQuantity,
      );
      try {
        await BookingService().bookProduct(booking);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully booked ${widget.product.name}'),
            duration: Duration(seconds: 2),
          ),
        );

        // Navigate to a success screen if needed
        // ...
      } catch (e) {
        print('Error booking product: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error booking ${widget.product.name}'),
            duration: Duration(seconds: 2),
          ),
        );
        // Handle the error as needed
      }

      // Show confirmation or navigate to a success screen
      // ...
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
                    // Handle the Buy Now button tap

                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    elevation: 0.2,
                  ),
                  child: Text("Book Now"),
                ),
              ),
              IconButton(
                onPressed:_addToCart,
                icon: Icon(Icons.add_shopping_cart),
                color: Colors.green,
              ),
              IconButton(
                onPressed: () {
                  // Handle the favorite button tap
                },
                icon: Icon(Icons.favorite_border),
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

void addToCart(Product product, int quantity) {
  // Handle the logic to add the product to the cart
  // You can customize this logic based on your requirements
}