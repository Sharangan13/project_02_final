import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'SessionTimeout.dart';

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
  List<DocumentSnapshot> _ordersList = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collectionGroup("UserBooking")
          .where('status', isEqualTo: 'pending')
          .get();

      setState(() {
        _ordersList = snapshot.docs;
        _loading = false; // Set loading to false after data is loaded
      });
    } catch (e) {
      print('Error loading orders: $e');
      // Handle the error, show a message, or retry the operation
      setState(() {
        _loading = false; // Set loading to false even in case of an error
      });
    }
  }

  List<DocumentSnapshot> _filterOrders() {
    if (_searchQuery.isEmpty) {
      return _ordersList;
    }

    return _ordersList.where((order) {
      final orderData = order.data() as Map<String, dynamic>;
      final userEmail = orderData['UserEmail'].toString().toLowerCase();
      final searchQuery = _searchQuery.toLowerCase();

      return userEmail.contains(searchQuery);
    }).toList();
  }

  Future<void> _markAsFinished(DocumentSnapshot orderDocument) async {
    bool confirmAction = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Finished Order",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
          ),
          content: Text(
              "Are you sure you want to finish this order? confirm you recieved ammount"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                SessionTimeout().onUserInteraction();

                Navigator.of(context).pop(false);
              },
              child: Text(
                'No',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () {
                SessionTimeout().onUserInteraction();

                Navigator.of(context).pop(true);
              },
              child: Text(
                "Yes",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ),
          ],
        );
      },
    );

    if (confirmAction ?? true) {
      await orderDocument.reference.update({'payment': 'complete'});
      await orderDocument.reference.update({'status': 'complete'});

      await _loadOrders();
    }
  }

  Future<void> _cancelOrderAction(DocumentSnapshot orderDocument) async {
    bool confirmAction = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Cancel Order WARNING....",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          content: Text(
              "Are you sure you want to cancel this order? If the customer has already paid, you must refund the amount manually"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                SessionTimeout().onUserInteraction();

                Navigator.of(context).pop(false);
              },
              child: Text(
                'No',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                SessionTimeout().onUserInteraction();

                Navigator.of(context).pop(true);
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );

    if (confirmAction) {
      if (orderDocument['status'] == 'pending') {
        await orderDocument.reference.update({'status': 'cancelled'});
      }
      final documentReference = FirebaseFirestore.instance
          .collection(orderDocument['category'].trim() == 'equipments'
              ? 'Equipments'
              : 'Plants')
          .doc(orderDocument['category'].trim())
          .collection('Items')
          .doc(orderDocument['productId']);

      // Retrieve the current quantity value as a string
      documentReference.get().then((docSnapshot) {
        if (docSnapshot.exists) {
          // Get the current quantity as a string
          final currentQuantityString = docSnapshot.data()?['quantity'];

          // Convert the current quantity string to an integer
          final currentQuantityInt = int.tryParse(currentQuantityString) ?? 0;

          // Update the quantity by adding the new quantity
          final newQuantityInt = currentQuantityInt + orderDocument['quantity'];

          // Convert the new quantity integer back to a string
          final newQuantityString = newQuantityInt.toString();

          // Update the Firestore document with the new quantity string
          documentReference.update({
            'quantity': newQuantityString,
          });
        }
      });

      await _loadOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredOrders = _filterOrders();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Search using Customer email..',
                  suffixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: _loading
              ? Center(child: CircularProgressIndicator()) // Loading indicator
              : filteredOrders.isEmpty
                  ? Center(
                      child: Text(
                        'No matching orders found',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredOrders.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot userBookingDocument =
                            filteredOrders[index];
                        OrderModel order = OrderModel(
                            userEmail: userBookingDocument['UserEmail'],
                            imageUrl: userBookingDocument['image_url'],
                            name: userBookingDocument['name'],
                            quantity: userBookingDocument['quantity'],
                            payment: userBookingDocument['payment'],
                            date: userBookingDocument['date'],
                            category: userBookingDocument['category'],
                            total: userBookingDocument['total'],
                            productId: userBookingDocument['productId']);

                        return Card(
                          elevation: 3,
                          margin:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            title: Text(
                              '${order.userEmail}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Name: ${order.name}'),
                                    Text('Quantity: ${order.quantity}'),
                                    Text(
                                      'Payment: ${order.payment}',
                                      style: TextStyle(
                                          color: order.payment == 'complete'
                                              ? Colors.green
                                              : Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text('Total: ${order.total}'),
                                    Text('Date: ${order.date}'),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            SessionTimeout()
                                                .onUserInteraction();
                                            _markAsFinished(
                                                userBookingDocument);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                          ),
                                          icon: Icon(Icons.check),
                                          label: Text('Finish'),
                                        ),
                                        SizedBox(width: 20),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            _cancelOrderAction(
                                                userBookingDocument);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                          ),
                                          icon: Icon(Icons.delete),
                                          label: Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(order.imageUrl ?? ''),
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}

class OrderModel {
  final String? userEmail;
  final String? imageUrl;
  final String? name;
  final int? quantity;
  final String? payment;
  final String? status;
  final String? date;
  final String? category;
  final String? productId;
  final double? total;

  OrderModel(
      {this.userEmail,
      this.imageUrl,
      this.name,
      this.quantity,
      this.total,
      this.payment,
      this.date,
      this.category,
      this.productId,
      this.status});
}
