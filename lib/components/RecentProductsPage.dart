import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Pages/product_details.dart';

class RecentProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Product>>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No products found'),
            );
          }

          final products = snapshot.data!;

          return GridView.builder(
            padding: EdgeInsets.all(8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.7,
            ),
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) {
              final product = products[index];
              return GestureDetector(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(8.0),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(product.imageURL),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Padding(
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
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              'Rs ${product.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              'Quantity: ${product.quantity}',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<Product>> fetchProducts() async {
    final collectionPaths = [
      'FloweringPlants',
      'IndoorPlants',
      'MedicinalPlants',
      'OutdoorPlants',
      'RareandExoticPlants',
    ];

    final List<Product> products = [];

    for (final collectionPath in collectionPaths) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Plants')
          .doc(collectionPath)
          .collection('Items')
          .orderBy('date', descending: true)
          .limit(100)
          .get();

      final collectionProducts =
          querySnapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();

      products.addAll(collectionProducts);
    }

    products.sort((a, b) => b.date.compareTo(a.date));

    return products;
  }
}

class Product {
  final String name;
  final double price;
  final String imageURL;
  final String description;
  final int quantity;
  final DateTime date;

  Product({
    required this.name,
    required this.price,
    required this.imageURL,
    required this.description,
    required this.quantity,
    required this.date,
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
    final dateTimestamp = data['date'] as Timestamp? ?? Timestamp.now();
    final date = dateTimestamp.toDate();

    return Product(
      name: name,
      price: price,
      imageURL: imageURL,
      description: description,
      quantity: quantity,
      date: date,
    );
  }
}
