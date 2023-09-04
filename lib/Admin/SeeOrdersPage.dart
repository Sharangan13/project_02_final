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

  Future<void> _markAsFinished(DocumentSnapshot orderDocument) async {
    // Delete the order from Firestore
    await orderDocument.reference.delete();

    // Reload the orders after deletion
    await _loadOrders();
  }

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
                trailing: ElevatedButton(
                  onPressed: () {
                    _markAsFinished(userBookingDocument);
                  },
                  child: Text('Finished'),
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
