import 'package:flutter/material.dart';
import 'Product.dart';
import 'cart.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartItems = Cart.items;
    double totalAmount = Cart.getTotalAmount();

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
            subtitle: Text('Quantity: ${cartItem.quantity}'),
            trailing: Text('Rs ${(cartItem.product.price * cartItem.quantity).toStringAsFixed(2)}'),
            // Add a button to remove the item from the cart
            // You can use the removeFromCart method from the Cart class
            // to remove the item from the cart list.
            // For simplicity, let's use an icon button here.
            // onPressed: () => Cart.removeFromCart(cartItem.product.productId),
            // icon: Icon(Icons.remove_shopping_cart),
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
