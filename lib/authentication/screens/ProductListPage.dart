import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Pages/product_details.dart';

class ProductListPage extends StatelessWidget {
  final String category;

  const ProductListPage({required this.category, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Plants')
            .doc(category)
            .collection('Items')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching products'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No products found'),
            );
          }

          final products = snapshot.data!.docs
              .map((doc) => Product.fromSnapshot(doc))
              .toList();

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                child: InkWell(
                  onTap: () {
                    // Handle the product tap
                    // You can add your logic here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetails(
                          product: product,
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: Image.network(
                      product.imageURL,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                    ),
                    title: Text(product.name),
                    subtitle: Text('Rs ${product.price.toStringAsFixed(2)}'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class Product {
  final String name;
  final double price;
  final String imageURL;
  final String description;
  final int quantity;

  Product({
    required this.name,
    required this.price,
    required this.imageURL,
    required this.description,
    required this.quantity,
  });

  factory Product.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    final name = data['name'] as String? ?? '';
    final priceString = data['price'] as String? ?? '';
    final price = double.tryParse(priceString) ?? 0.0;
    final imageURL = data['image_url'] as String? ?? '';
    final description = data['description'] as String? ?? '';
    final quantityString = data['quantity'] as String? ?? '';
    final quantity = int.tryParse(quantityString) ?? 0;

    return Product(
      name: name,
      price: price,
      imageURL: imageURL,
      description: description,
      quantity: quantity,
    );
  }
}
