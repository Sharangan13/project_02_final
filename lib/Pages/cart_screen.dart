import 'package:flutter/material.dart';
import 'Product.dart';
import 'cart.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> cartItems = Cart.items;
  double totalAmount = Cart.getTotalAmount();

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
            elevation: 2,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              leading: Image.network(cartItem.product.imageURL),
              title: Text(
                cartItem.product.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Text('Quantity: ${cartItem.quantity}'),
                  Text(
                    'Total: Rs ${(cartItem.product.price * cartItem.quantity).toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  _removeItem(cartItem);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // Customize button color
                ),
                child: Text(
                  'Remove',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: Rs ${totalAmount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle the checkout process
                  // For simplicity, we can just show a snackbar here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Checkout functionality not implemented.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green, // Customize button color
                ),
                child: Text(
                  'Checkout',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
