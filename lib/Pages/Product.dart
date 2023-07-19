import 'package:cloud_firestore/cloud_firestore.dart';

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
