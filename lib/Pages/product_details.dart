import 'package:flutter/material.dart';

import 'Product.dart';

class ProductDetails extends StatefulWidget {
  final Product product;

  const ProductDetails({required this.product});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int selectedQuantity = 1;

  @override
  Widget build(BuildContext context) {
    double totalAmount = selectedQuantity * widget.product.price;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text(widget.product.name),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        children: [
          Container(
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
                  onPressed: () {
                    // Handle the Buy Now button tap
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    elevation: 0.2,
                  ),
                  child: Text("Buy Now"),
                ),
              ),
              IconButton(
                onPressed: () {
                  addToCart(widget.product, selectedQuantity);
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
