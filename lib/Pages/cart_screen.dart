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

          return ListTile(
            leading: Image.network(cartItem.product.imageURL),
            title: Text(cartItem.product.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
              child: Text('Remove from Cart'),
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
              Text('Total: Rs ${totalAmount.toStringAsFixed(2)}'),
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
                child: Text('Checkout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
