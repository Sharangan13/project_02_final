import 'package:flutter/material.dart';
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
