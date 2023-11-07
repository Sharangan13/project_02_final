import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SeeOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('See Orders'),
      ),
      body: OrdersList(),
    );
  }
}

class OrdersList extends StatefulWidget {
  @override
  _OrdersListState createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  String _searchQuery = '';
  late QuerySnapshot _ordersSnapshot;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final snapshot = await FirebaseFirestore.instance.collectionGroup("UserBooking").get();
    setState(() {
      _ordersSnapshot = snapshot;
    });
  }

  List<DocumentSnapshot> _filterOrders() {
    if (_searchQuery.isEmpty) {
      return _ordersSnapshot.docs; // Return all orders if the search query is empty
    }

    return _ordersSnapshot.docs.where((order) {
      final orderData = order.data() as Map<String, dynamic>;
      final userEmail = orderData['UserEmail'].toString().toLowerCase(); // Modify the field name here
      final searchQuery = _searchQuery.toLowerCase();

      // Check if the User Email contains the search query
      return userEmail.contains(searchQuery);
    }).toList();
  }

  // finished key function
  Future<void> _markAsFinished(DocumentSnapshot orderDocument) async {
    // Show a confirmation dialog
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Mark'),
          content: Text('Are you sure you want to mark As Finished this order?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Return false when cancel button is pressed
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Return true when OK button is pressed
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );

    if (confirmDelete ?? false) {
      // User confirmed deletion, proceed with deletion
      await orderDocument.reference.delete();

      // Reload the orders after deletion
      await _loadOrders();
    }
  }
     // end of delete function
  // delete button function
  Future<void> _performOrderAction(DocumentSnapshot orderDocument) async {
    bool isCancellation = orderDocument['status'] == 'Pending';

    String dialogMessage = isCancellation ? 'Are you sure you want to cancel this order?' : 'Are you sure you want to delete the order?';
    String buttonLabel = isCancellation ? 'Cancel Order' : 'delete';

    bool confirmAction = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isCancellation ? 'Confirm Cancel' : 'Confirm delete'),
          content: Text(dialogMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(buttonLabel),
            ),
          ],
        );
      },
    );

    if (confirmAction ?? false) {
      if (isCancellation) {
        // Cancel order logic here
        await orderDocument.reference.update({'status': 'Cancelled'});
      } else {
        // Mark order as finished logic here
        await orderDocument.reference.update({'status': 'Finished'});
      }

      // Reload orders after the action
      await _loadOrders();
    }
  }  // end delete button function
  // end of delete button function
  @override
  Widget build(BuildContext context) {
    final filteredOrders = _filterOrders();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Search Here', // Update the label
              suffixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),
        Expanded(
          child: filteredOrders.isEmpty
              ? Center(
            child: Text(
              'No matching orders found',
              style: TextStyle(fontSize: 18),
            ),
          )
          : ListView.builder(
            itemCount: filteredOrders.length,
            itemBuilder: (context, index) {
              DocumentSnapshot userBookingDocument = filteredOrders[index];
              YourOrderModel order = YourOrderModel(
                userEmail: userBookingDocument['UserEmail'],
                category: userBookingDocument['category'],
                imageUrl: userBookingDocument['image_url'],
                name: userBookingDocument['name'],
                quantity: userBookingDocument['quantity'],
                status: userBookingDocument['status'],
              );

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
                leading: Image.network(order.imageUrl ?? ''),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _markAsFinished(userBookingDocument);
                      },
                      child: Text('Finished'),
                    ),
                    SizedBox(width: 10), // Add some spacing between buttons
                    ElevatedButton(
                      onPressed: () {
                        _performOrderAction(userBookingDocument);
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.red), // Set button color to red
                      child: Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),

        ),
      ],
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
void main() {
  runApp(MaterialApp(home: SeeOrdersPage()));
}
