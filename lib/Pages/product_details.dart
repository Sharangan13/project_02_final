import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../authentication/screens/ProductListPage.dart';

class ProductDetails extends StatelessWidget {
  final Product product;

  const ProductDetails({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text(product.name),
      ),
      body: ListView(
        children: [
          Container(
            height: 300.0,
            child: GridTile(
              child: Container(
                color: Colors.white,
                child: Image.network(product.imageURL),
              ),
              footer: Container(
                color: Colors.white70,
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      'Price: Rs ${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      'Quantity: ${product.quantity}',
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
          SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    // Handle the quantity button tap
                  },
                  color: Colors.white,
                  textColor: Colors.black,
                  elevation: 0.2,
                  child: Row(
                    children: [
                      Expanded(child: Text("Quantity")),
                      Expanded(child: Icon(Icons.arrow_drop_down)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    // Handle the Buy Now button tap
                  },
                  color: Colors.green,
                  textColor: Colors.white,
                  elevation: 0.2,
                  child: Text("Buy Now"),
                ),
              ),
              IconButton(
                onPressed: () {
                  // Handle the add to cart button tap
                },
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
            title: Text("Description"),
            subtitle: Text(
              product.description,
            ),
          ),
          Divider(color: Colors.green),
          Row(
            children: [],
          ),
        ],
      ),
    );
  }
}
