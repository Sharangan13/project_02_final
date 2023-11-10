import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Product.dart';
import 'cart.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

// Define a Booking class to represent booking information
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
  String date; // Updated to use a string for the date

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
    required this.date,
  });

  // Convert Booking object to a map for Firestore storage
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
      'date': date,
    };
  }
}

class _CartScreenState extends State<CartScreen> {
  // Retrieve cart items and total amount from the Cart class
  List<CartItem> cartItems = Cart.items;
  double totalAmount = Cart.getTotalAmount();

  // Function to remove an item from the cart
  void _removeItem(CartItem cartItem) {
    setState(() {
      Cart.removeItem(cartItem.product);
      cartItems = Cart.items;
      totalAmount = Cart.getTotalAmount();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Item removed from cart.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Function to update product quantities in Firestore
  Future<void> _updateProductQuantities(List<CartItem> cartItems) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    for (CartItem cartItem in cartItems) {
      try {
        final DocumentReference productDoc = FirebaseFirestore.instance
            .collection(cartItem.product.Category.trim() == "equipments"
                ? 'Equipments'
                : 'Plants')
            .doc(cartItem.product.Category.trim() == "equipments"
                ? "equipments"
                : cartItem.product.Category)
            .collection('Items')
            .doc(cartItem.product.productId);

        final docSnapshot = await productDoc.get();

        if (docSnapshot.exists) {
          // Get the current available quantity from the Firestore document
          int currentAvailableQuantity =
              int.parse(docSnapshot['quantity'] ?? '0');

          // Calculate the new available quantity after deducting the selected quantity
          int newAvailableQuantity =
              currentAvailableQuantity - cartItem.quantity;

          // Update the product's availableQuantity property in memory to reflect the change
          cartItem.product.quantity = newAvailableQuantity;

          // Update the quantity in Firestore
          await productDoc
              .update({'quantity': newAvailableQuantity.toString()});

          print('Quantity updated successfully for ${cartItem.product.name}');
        } else {
          print('Document does not exist for ${cartItem.product.name}');
        }
      } catch (error) {
        print('Error updating quantity for ${cartItem.product.name}: $error');
        // Handle the error as needed
      }
    }
  }

  // Function to fetch discount percentages from Firestore
  Future<Map<String, double>> fetchPercentages() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final Map<String, double> percentages = {};

    try {
      // Reference to the "offers" collection and "percentages" document
      final DocumentReference docRef =
          _firestore.collection('offers').doc('percentages');

      // Get the document data
      final DocumentSnapshot docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;

        // Access the fields "equipmentPercentage" and "plantsPercentage"
        final double equipmentPercentage = data['equipmentPercentage'] ?? 0.0;
        final double plantsPercentage = data['plantsPercentage'] ?? 0.0;

        percentages['equipmentPercentage'] = equipmentPercentage;
        percentages['plantsPercentage'] = plantsPercentage;
      }
    } catch (e) {
      print('Error fetching data: $e');
    }

    return percentages;
  }

  // Function to initiate the booking process
  Future<String> _bookNow() async {
    // Get the current user
    final user = FirebaseAuth.instance.currentUser;

    // Check if the cart is empty
    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please add products to the cart before booking.'),
          duration: Duration(seconds: 2),
        ),
      );

      return 'Booking failed';
    }

    // Show a confirmation dialog
    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Booking'),
          content: Text('Are you sure you want to book these items?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User canceled the operation
              },
              child: Text('Cancel',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User confirmed the operation
              },
              child: Text('Confirm',
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );

    // If the user confirmed and the cart is not empty, proceed with booking
    if (confirmed == true) {
      await _updateProductQuantities(cartItems); // Ensure proper await here

      // Create a Booking object with the total amount and quantity of the cart
      Booking newBooking = Booking(
        status: 'Pending',
        category: 'Combined', // Update with an appropriate category
        image_url: '', // Update with an appropriate image URL
        name: 'Combined Booking', // Update with an appropriate name
        total: totalAmount,
        quantity: cartItems.length,
        email: user?.email ?? '',
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      );

      // Check booking criteria
      bool bookingAllowed = await checkBookingCriteria(newBooking);

      if (bookingAllowed) {
        await _processBooking(user);

        // Show a confirmation message or navigate to a success screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking successful. Cart cleared.'),
            duration: Duration(seconds: 2),
          ),
        );

        // Clear the cart after booking
        setState(() {
          Cart.items.clear();
          totalAmount = 0; // Update totalAmount
          Cart.cartUpdatedCallback?.call();
        });

        return 'Booking successful';
      } else {
        // Show an alert dialog indicating that the booking criteria are not met
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Booking Criteria Not Met'),
              content: Text(
                'Kindly note that you have reached the maximum booking limit. If you would like to proceed with the booking, we kindly request you to pay the full booking amount.',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    // Add your logic for the "Continue Booking" option here
                    Navigator.of(context).pop();
                    // Call the function to handle the continuation of booking
                    // e.g., _continueBooking();
                  },
                  child: Text(
                    'Continue Booking',
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Add your logic for the "Cancel" option here
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );

        return 'Booking criteria not met';
      }
    }

    // User canceled the booking
    return 'Booking canceled';
  }

  // Function to process the booking and store data in Firestore
  Future<void> _processBooking(User? user) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // Ensure the user is not null
    if (user != null) {
      // Fetch the discount percentages data
      final percentages = await fetchPercentages();

      for (CartItem cartItem in cartItems) {
        Product product = cartItem.product;

        // Use the fetched values to calculate the adjusted total
        double equipmentPercentage = percentages['equipmentPercentage'] ?? 0.0;
        double plantsPercentage = percentages['plantsPercentage'] ?? 0.0;

        double adjustedTotal;

        // Determine the category and apply the discount accordingly
        if (cartItem.product.Category.trim() == "equipments") {
          adjustedTotal = (cartItem.product.price) -
              (cartItem.product.price * equipmentPercentage / 100.0);
        } else {
          adjustedTotal = (cartItem.product.price) -
              (cartItem.product.price * plantsPercentage / 100.0);
        }

        // Create a Booking object with the calculated total
        Booking booking = Booking(
          status: 'Pending',
          category: product.Category,
          image_url: product.imageURL,
          name: product.name,
          total: adjustedTotal,
          quantity: cartItem.quantity,
          email: user.email,
          productId: product.productId,
          date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        );

        try {
          // Add the booking to Firestore
          final DocumentReference docRef = await _firestore
              .collection('Booking')
              .doc(user.uid)
              .collection("UserBooking")
              .add(booking.toMap());

          final bookingId = docRef.id;
          booking.bookingId = bookingId;

          // Update the 'bookingId' field in Firestore
          await docRef.update({'bookingId': bookingId});
        } catch (e) {
          print('Error booking product: $e');
          // Handle the error as needed
          return null;
        }
      }

      // Clear the cart after booking
      setState(() {
        Cart.items.clear();
        Cart.cartUpdatedCallback?.call();
      });
    }
  }

  Future<bool> checkBookingCriteria(Booking newBooking) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    // Fetch the user's existing bookings
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Booking')
        .doc(currentUser!.uid)
        .collection("UserBooking")
        .get();

    double totalAmount = 0.0;
    int totalQuantity = 0;

    for (final QueryDocumentSnapshot doc in querySnapshot.docs) {
      final bookingData = doc.data() as Map<String, dynamic>;
      final quantity =
          (bookingData['quantity'] ?? 0) as int; // Ensure it's an int
      final total =
          (bookingData['total'] ?? 0) as double; // Ensure it's a double

      totalQuantity += quantity;
      totalAmount += total;
    }

    // Calculate the total amount of the new booking as a double
    double newBookingTotal = newBooking.total * newBooking.quantity;

    if ((totalQuantity + newBooking.quantity) > 15 ||
        (totalAmount + newBookingTotal) > 15000.0) {
      return false; // Criteria not met
    }

    return true; // Criteria met, booking is allowed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final cartItem = cartItems[index];

          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: Image.network(
                cartItem.product.imageURL,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
              title: Text(cartItem.product.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Quantity: ${cartItem.quantity}'),
                  Text(
                    'Total: Rs ${(cartItem.product.price * cartItem.quantity).toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              trailing: IconButton(
                onPressed: () {
                  _removeItem(cartItem);
                },
                icon: Icon(Icons.remove_shopping_cart),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: Rs ${totalAmount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: _bookNow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  textStyle: TextStyle(fontSize: 16),
                ),
                child: Text('Book now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
