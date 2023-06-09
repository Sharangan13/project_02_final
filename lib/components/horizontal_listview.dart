import 'package:flutter/material.dart';

class horizontalList extends StatelessWidget {
  const horizontalList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Category(
            imageLocation: 'assets/types/O1.jpg',
            imageCaption: 'Equipments',
            onTap: () {
              // Handle Equipment category tap
              // You can add your logic here
              print('Equipment category tapped');
            },
          ),
          Category(
            imageLocation: 'assets/types/O1.jpg',
            imageCaption: 'Flowering Plants',
            onTap: () {
              // Handle Flowering Plants category tap
              // You can add your logic here
              print('Flowering Plants category tapped');
            },
          ),
          Category(
            imageLocation: 'assets/types/O1.jpg',
            imageCaption: 'Indoor Plants',
            onTap: () {
              // Handle Indoor Plants category tap
              // You can add your logic here
              print('Indoor Plants category tapped');
            },
          ),
          Category(
            imageLocation: 'assets/types/O1.jpg',
            imageCaption: 'Medicinal Plants',
            onTap: () {
              // Handle Medicinal Plants category tap
              // You can add your logic here
              print('Medicinal Plants category tapped');
            },
          ),
          Category(
            imageLocation: 'assets/types/O1.jpg',
            imageCaption: 'Exotic Plants',
            onTap: () {
              // Handle Exotic Plants category tap
              // You can add your logic here
              print('Exotic Plants category tapped');
            },
          ),
        ],
      ),
    );
  }
}

class Category extends StatelessWidget {
  final String imageLocation;
  final String imageCaption;
  final VoidCallback onTap;

  const Category({
    required this.imageLocation,
    required this.imageCaption,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 100.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  imageLocation,
                  width: 100.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                imageCaption,
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
